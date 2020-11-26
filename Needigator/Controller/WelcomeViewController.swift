//
//  WelcomeViewController.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 16.03.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    

    @IBOutlet weak var shoppingButtonView: UIView!
    @IBOutlet weak var shoppingListButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Shopping.selectedProductsOfUser.removeAll()
    
    title = "Needigator"
        
    //UI-Layout Anpassungen
    shoppingButtonView.layer.cornerRadius = 12
    shoppingButtonView.layer.shadowColor = UIColor.gray.cgColor
    shoppingButtonView.layer.shadowOpacity = 0.4
    shoppingButtonView.layer.shadowOffset = .zero
    shoppingButtonView.layer.shadowRadius = 10
    
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
}


