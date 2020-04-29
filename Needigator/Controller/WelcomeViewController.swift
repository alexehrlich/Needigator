//
//  WelcomeViewController.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 16.03.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var angebotButton: UIButton!
    @IBOutlet weak var kategorieButton: UIButton!
    @IBOutlet weak var navigationButton: UIButton!
    @IBOutlet weak var whateverButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        angebotButton.layer.cornerRadius = angebotButton.frame.size.height / 5
        
        kategorieButton.layer.cornerRadius = kategorieButton.frame.size.height / 5
        
        navigationButton.layer.cornerRadius = navigationButton.frame.size.height / 5
        
        whateverButton.layer.cornerRadius = whateverButton.frame.size.height / 5
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }

}


