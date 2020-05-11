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
    
    override func viewWillAppear(_ animated: Bool) {
        navigationArrowImage.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       navigation.delegate = self
       navigation.drawImage(nodes: nodesInRoute)
        
        moveNavigationArrow()
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
    
    func moveNavigationArrow(){
        
        let startingPoint = CGPoint(x: routeImageView.center.x - routeImageView.frame.size.width/2, y: routeImageView.center.y - routeImageView.frame.size.height/2)
        
        if recursiveCounter < pixelCoordinatesInRoute.count {
            
             navigationArrowImage.center = CGPoint(x: startingPoint.x + pixelCoordinatesInRoute[recursiveCounter].x/3, y: startingPoint.y + pixelCoordinatesInRoute[recursiveCounter].y/3)
            
            let timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: false) { (timer) in
                
                self.recursiveCounter += 1
                self.moveNavigationArrow()
            }
        }else{
            recursiveCounter = 0
            moveNavigationArrow()
        }
        
    }
    
}
