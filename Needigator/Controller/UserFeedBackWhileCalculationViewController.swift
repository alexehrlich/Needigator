//
//  UserFeedBackWhileCalculationViewController.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 25.10.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit

class UserFeedBackWhileCalculationViewController: UIViewController {

    @IBOutlet weak var bigGearImageView: UIImageView!
    @IBOutlet weak var smallGearImageView: UIImageView!
    
    var degreeBigGearImageView = 0
    var degreeSmallGearImageView = 0

    
    override func viewDidAppear(_ animated: Bool) {
      
        for n in 1...10{
            UIView.animate(withDuration: 4, animations: {
                self.bigGearImageView.transform = CGAffineTransform(rotationAngle: CGFloat(n * 1))
                
                self.smallGearImageView.transform = CGAffineTransform(rotationAngle: CGFloat(-1 * n))
            })
        
        }
    }

}
