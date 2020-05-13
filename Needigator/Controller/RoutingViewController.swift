//
//  RoutingViewController.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 24.03.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit

class RoutingViewController: UIViewController, ImageTransfer {
    
    
    
    @IBOutlet weak var routeImageView: UIImageView!
    @IBOutlet weak var navigationArrowImage: UIImageView!
    
    var navigation = Navigation()
    var nodesInRoute = [Int]()
    var pixelCoordinatesInRoute = [CGPoint]()
    
    var recursiveCounter = 0
    var secondRecursiveCounter = 0
    
    
    var seconNAvigationArrowImage = UIImage()
    var secondNavigationArrowImageView = UIImageView()
    
    var firstHalfDone = false
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationArrowImage.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigation.delegate = self
        navigation.drawImage(nodes: nodesInRoute)
        navigationArrowImage.alpha = 0
        
        seconNAvigationArrowImage = UIImage(systemName: "cart")!
        secondNavigationArrowImageView = UIImageView(image: seconNAvigationArrowImage)
        secondNavigationArrowImageView.tintColor = .white
        secondNavigationArrowImageView.contentMode = .scaleAspectFit
        secondNavigationArrowImageView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 20, height: 20))
        self.view.addSubview(secondNavigationArrowImageView)
        
        
        let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            
            self.moveFirstNavigationArrow()
        }
        
    }
    
    func receiveImage(image: UIImage) {
        routeImageView.image = image
        
    }
    
    func receiveImagePixelData(points: [CGPoint]) {
        pixelCoordinatesInRoute = points
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        navigationArrowImage.isHidden = false
    }
    
    func moveFirstNavigationArrow(){
        
        if Double(recursiveCounter)/Double(pixelCoordinatesInRoute.count) > 0.5 {
            firstHalfDone = true
        }
        
        if recursiveCounter == 0 {
            UIView.animate(withDuration: 0.8) {
                self.navigationArrowImage.alpha = 1
            }
            
        }
        
        if recursiveCounter > pixelCoordinatesInRoute.count - 40 {
            navigationArrowImage.alpha *= 0.9
        }
        
        let startingPoint = CGPoint(x: routeImageView.center.x - routeImageView.frame.size.width/2, y: routeImageView.center.y - routeImageView.frame.size.height/2)
        
        if recursiveCounter < pixelCoordinatesInRoute.count {
            
            navigationArrowImage.center = CGPoint(x: startingPoint.x + pixelCoordinatesInRoute[recursiveCounter].x/3, y: startingPoint.y + pixelCoordinatesInRoute[recursiveCounter].y/3)
            
            
            
            let _ = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: false) { (timer) in
                
                self.recursiveCounter += 1
                self.moveFirstNavigationArrow()
                
                if self.firstHalfDone == true {
                   self.moveSecondNavigationArrow()
                }
                
            }
        }else{
            recursiveCounter = 0
            moveFirstNavigationArrow()
        }
    }
    
    func moveSecondNavigationArrow(){
        
        if self.secondRecursiveCounter == 0{
            UIView.animate(withDuration: 0.8) {
                self.secondNavigationArrowImageView.alpha = 1
            }
        }
        
        if secondRecursiveCounter > pixelCoordinatesInRoute.count - 40 {
                       secondNavigationArrowImageView.alpha *= 0.9
                   }
        
        let startingPoint = CGPoint(x: routeImageView.center.x - routeImageView.frame.size.width/2, y: routeImageView.center.y - routeImageView.frame.size.height/2)
        
        if secondRecursiveCounter < pixelCoordinatesInRoute.count {
            
           
            
            secondNavigationArrowImageView.center = CGPoint(x: startingPoint.x + pixelCoordinatesInRoute[secondRecursiveCounter].x/3, y: startingPoint.y + pixelCoordinatesInRoute[secondRecursiveCounter].y/3)
            
            let _ = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: false) { (timer) in
                

                self.secondRecursiveCounter += 1
                //self.moveSecondNavigationArrow()
            }
        }else{
            secondRecursiveCounter = 0
            moveSecondNavigationArrow()
        }
    }
    
    
}
