//
//  RoutingViewController.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 24.03.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit

class RoutingViewController: UIViewController, RouteCalculationManagerDelegate {
    
    
    
    @IBOutlet weak var routeImageView: UIImageView!
    @IBOutlet weak var navigationArrowImage: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    var navigation = RouteCalculationManager()
    var nodesInRoute = [Int]()
    var pixelCoordinatesInRoute = [CGPoint]()
    var pixelCordinatesOfNodesInRoute = [Int:CGPoint]()
    
    let articleDataBase = ArticleDataBase()
   
    
    var recursiveCounter = 0
    var secondRecursiveCounter = 0
    
    
    var seconNAvigationArrowImage = UIImage()
    var secondNavigationArrowImageView = UIImageView()
    
    var firstHalfDone = false
    
    
    //InformationView Stuff
    @IBOutlet weak var informationView: UIView!
    @IBOutlet weak var articleNameInView: UILabel!
    @IBOutlet weak var articlePriceInView: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.light))
      

    override func viewWillAppear(_ animated: Bool) {
        
        
        navigationArrowImage.isHidden = true
        informationView.alpha = 0
        
        for node in nodesInRoute{
            let startingPoint = CGPoint(x: routeImageView.center.x - routeImageView.frame.size.width/2, y: routeImageView.center.y - routeImageView.frame.size.height/2)
            let newProductPinButton = UIButton()
            newProductPinButton.frame = CGRect(origin: CGPoint(x: startingPoint.x + pixelCordinatesOfNodesInRoute[node]!.x/3, y: startingPoint.y + pixelCordinatesOfNodesInRoute[node]!.y/3), size: CGSize(width: 20, height: 20))
            newProductPinButton.center = CGPoint(x: startingPoint.x + pixelCordinatesOfNodesInRoute[node]!.x/3, y: startingPoint.y + pixelCordinatesOfNodesInRoute[node]!.y/3 - newProductPinButton.frame.size.height/2)
            newProductPinButton.setImage(UIImage(named: "product_map"), for: .normal)
            newProductPinButton.imageView?.tintColor = .white
            newProductPinButton.addTarget(self, action: #selector(productMapButtonPressed), for: .touchUpInside)
            newProductPinButton.alpha = 1
            newProductPinButton.isHidden = false
            newProductPinButton.tag = node
            self.view.addSubview(newProductPinButton)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        informationView.layer.cornerRadius = 10
        
        navigation.delegate = self
        navigation.drawImage(nodes: nodesInRoute)
        navigationArrowImage.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        navigationArrowImage.alpha = 0
        
        seconNAvigationArrowImage = UIImage(systemName: "cart")!
        secondNavigationArrowImageView = UIImageView(image: seconNAvigationArrowImage)
        secondNavigationArrowImageView.tintColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        secondNavigationArrowImageView.contentMode = .scaleAspectFit
        secondNavigationArrowImageView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 20, height: 20))
        secondNavigationArrowImageView.isHidden = true
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
            secondNavigationArrowImageView.isHidden = false
            let _ = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: false) { (timer) in
                

                self.secondRecursiveCounter += 1
               
            }
        }else{
            secondRecursiveCounter = 0
            moveSecondNavigationArrow()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        
        if touch?.view != informationView {
            
            UIView.animate(withDuration: 0.5) {
                self.informationView.alpha = 0
                self.blurEffectView.removeFromSuperview()
            }
            
        }
        
            }
    
    @objc func productMapButtonPressed(button: UIButton){
        
        print(button.tag)
        
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
        //INFO: positionierung funktioniet noch nicht!
        informationView.frame.origin = CGPoint(x: button.center.x , y: button.center.y + button.frame.size.height/2)
        
        for article in articleDataBase.items {
            
            if button.tag == article.getNode() {
                
                articleImageView.image = article.getImage()
                articleNameInView.text = article.getName()
                articlePriceInView.text = article.getPrice()
            }
        }
        
        informationView.backgroundColor = .white
        self.view.addSubview(informationView)
        informationView.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.informationView.alpha = 1
        }
    }
}


