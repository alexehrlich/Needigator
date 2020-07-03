//
//  WelcomeViewController.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 16.03.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    

    @IBOutlet weak var shoppingPlanButton: UIButton!
    @IBOutlet weak var shoppingListButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        shoppingPlanButton.layer.cornerRadius = 12
        shoppingListButton.layer.cornerRadius = 12
        helpButton.layer.cornerRadius = 12
        
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = false

    }
    
}


