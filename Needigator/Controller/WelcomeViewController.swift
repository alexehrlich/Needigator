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
        shoppingPlanButton.layer.shadowColor = UIColor.gray.cgColor
        shoppingPlanButton.layer.shadowOpacity = 0.4
        shoppingPlanButton.layer.shadowOffset = .zero
        shoppingPlanButton.layer.shadowRadius = 10
        
        shoppingListButton.layer.cornerRadius = 12
        shoppingListButton.layer.shadowColor = UIColor.gray.cgColor
        shoppingListButton.layer.shadowOpacity = 0.3
        shoppingListButton.layer.shadowOffset = .zero
        shoppingListButton.layer.shadowRadius = 10
        
        helpButton.layer.cornerRadius = 12
        helpButton.layer.shadowColor = UIColor.gray.cgColor
        helpButton.layer.shadowOpacity = 0.3
        helpButton.layer.shadowOffset = .zero
        helpButton.layer.shadowRadius = 10
        
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = false

    }
    
}


