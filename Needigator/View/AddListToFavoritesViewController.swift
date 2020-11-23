//
//  AddListToFavoritesViewController.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 23.11.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit

class AddListToFavoritesViewController: UIViewController {
    
    
    @IBOutlet weak var listNameEnterTextField: UITextField!
    @IBOutlet weak var textFieldView: UIView!
    @IBOutlet weak var addListButtonOutlet: UIButton!
    @IBOutlet weak var cancleButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldView.layer.cornerRadius = textFieldView.frame.size.height/2
        
        addListButtonOutlet.layer.cornerRadius = addListButtonOutlet.frame.size.height/2
        
        cancleButtonOutlet.layer.cornerRadius = cancleButtonOutlet.layer.frame.size.height/2
    }
    
    @IBAction func addListButtonPressed(_ sender: UIButton) {
        
        if listNameEnterTextField.text == ""{
            //User Feedback
        }else{
            //Add List to Model
            Shopping.favoriteShoppingLists[listNameEnterTextField.text!] = Shopping.selectedProductsOfUser
            
            UIView.animate(withDuration: 0.8) {
                self.view.frame.origin = CGPoint(x: 60, y: (self.view.superview?.frame.height)!)
            } completion: { (true) in
                self.view.removeFromSuperview()
                self.removeFromParent()
            }
        }
    }
    
    
    @IBAction func cancleListButtonPressed(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.8) {
            self.view.frame.origin = CGPoint(x: 60, y: (self.view.superview?.frame.height)!)
        } completion: { (true) in
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
    
    
}
