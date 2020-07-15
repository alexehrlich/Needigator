//
//  MarketSearchViewController.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 07.07.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit
import MapKit

class MarketSearchViewController: UIViewController, MarketViewControllerButtonDelegate{
    
    
    
    
    enum CardState {
        case expanded
        case collapsed
    }
    
    var cardViewController:CardViewController!
    var visualEffectView:UIVisualEffectView!
    
    let cardHeight:CGFloat = 600
    let cardHandleAreaHeight:CGFloat = 150
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    var cardVisible = false
    var nextState:CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Marktsuche"
        
        
        //Map setup
        let appleHQ = CLLocation(latitude: 37.335556, longitude: -122.009167)
        let regionRadius : CLLocationDistance = 1000.0
        let region = MKCoordinateRegion(center: appleHQ.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
        
        //Tastatur soll verschwinden, wenn irgendwo getippt wird
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        
        //NotifcationCenter setup for keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(prepareKeyBoardHideAndShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(prepareKeyBoardHideAndShow), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        setupCard()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        cardVisible = true
        animateTransitionIfNeeded(state: nextState, duration: 0.1)
    }
    
    
    
    func setupCard() {
        
        cardViewController = CardViewController(nibName:"CardViewController", bundle:nil)
        cardViewController.delegate = self
        self.addChild(cardViewController)
        self.view.addSubview(cardViewController.view)
        
        cardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight, width: self.view.bounds.width, height: cardHeight)
        cardViewController.view.layer.cornerRadius = 12
        
        
        cardViewController.view.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MarketSearchViewController.handleCardTap(recognzier:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(MarketSearchViewController.handleCardPan(recognizer:)))
        
        cardViewController.handleArea.addGestureRecognizer(tapGestureRecognizer)
        cardViewController.handleArea.addGestureRecognizer(panGestureRecognizer)
        
        
    }
    

    @objc func handleCardTap(recognzier:UITapGestureRecognizer) {

            print(cardViewController.tapIsWithinTextField)
            switch recognzier.state {
            case .ended:
                animateTransitionIfNeeded(state: nextState, duration: 0.9)
                
                if cardVisible == true {
                    self.view.endEditing(true)
                }
            default:
                break
            }
    }
    
    @objc
    func handleCardPan (recognizer:UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.9)
        case .changed:
            let translation = recognizer.translation(in: self.cardViewController.headBar)
            var fractionComplete = translation.y / cardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            
            if fractionComplete > 0 {
                self.view.endEditing(true)
            }
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
        
    }
    
    func animateTransitionIfNeeded (state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight
                case .collapsed:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight
                }
            }
            
            frameAnimator.addCompletion { _ in
                
                self.cardVisible = !self.cardVisible
                
                self.runningAnimations.removeAll()
            }
            
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
        }
    }
    
    func startInteractiveTransition(state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            
            //Damit wird die Animation angehalten und interactiv.
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    func updateInteractiveTransition(fractionCompleted:CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    func continueInteractiveTransition (){
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
    
    //Segue
    func marketHasBeenChoosen() {
        self.view.endEditing(true)
        performSegue(withIdentifier: "goToWelcomeScreen", sender: self)
    }
    
    func chooseUsersLocation() {
        //        choose the useres location and display it on the map
    }
    
    func keyBoardShouldClose() {
        animateTransitionIfNeeded(state: nextState, duration: 0.9)
        self.view.endEditing(true)
    }
    
    @objc func prepareKeyBoardHideAndShow(){
        
        if cardVisible == false {
            animateTransitionIfNeeded(state: nextState, duration: 0.9)
        }
        
    }
    
    
}

