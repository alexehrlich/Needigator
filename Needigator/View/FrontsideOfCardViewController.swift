//
//  FrontsideOfCardViewController.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 19.10.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit

protocol FrontSideCardDelegate {
    func cardTapped()
}

class FrontsideOfCardViewController: UIViewController {
    
    @IBOutlet weak var cardBackgroundView: UIView!
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var productInformation: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var cardButton: UIButton!
    @IBOutlet weak var dataBackgroundView: UIView!
    
    var frontSideCardDelegate: FrontSideCardDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardBackgroundView.layer.cornerRadius = 10
    }
    
    @IBAction func cardTapped(_ sender: UIButton) {
        print("Card Tapped")
    }
}
