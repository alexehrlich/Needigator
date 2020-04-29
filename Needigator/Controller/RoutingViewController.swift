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
    
    override func viewWillAppear(_ animated: Bool) {
        navigationArrowImage.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       navigation.delegate = self
       navigation.drawImage(nodes: nodesInRoute)
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
    
}
