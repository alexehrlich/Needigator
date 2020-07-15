//
//  CardViewController.swift
//  CardViewAnimation
//
//  Created by Brian Advent on 26.10.18.
//  Copyright © 2018 Brian Advent. All rights reserved.
//

import UIKit

protocol MarketViewControllerButtonDelegate {
    func marketHasBeenChoosen()
    func chooseUsersLocation()
    func keyBoardShouldClose()
}

class CardViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var headBar: UIView!
    @IBOutlet weak var dragBar: UIView!
    @IBOutlet weak var getLocationView: UIView!
    @IBOutlet weak var myMarketButtonView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var texFieldRecteangleView: UIView!
    @IBOutlet weak var handleArea: UIView!
    
    
    var delegate: MarketViewControllerButtonDelegate!
    
    var tapIsWithinTextField = false
    
    override func viewDidLoad() {
        
       
        textField.delegate = self
        textField.returnKeyType = .search
        
        dragBar.layer.cornerRadius = dragBar.frame.size.height/2
        getLocationView.layer.cornerRadius = getLocationView.frame.size.height/2
       myMarketButtonView.layer.cornerRadius = myMarketButtonView.frame.size.height/2
        
        textField.addTarget(self, action: #selector(setTexFieldTappedFlag), for: .touchDown)
        
    }
    
    @IBAction func myMarketButtonPressed(_ sender: UIButton) {
        delegate.marketHasBeenChoosen()
    }
    
    
    @IBAction func myLocationButtonPressed(_ sender: UIButton) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate.keyBoardShouldClose()
        return false
    }
    
    @objc func setTexFieldTappedFlag(){
        tapIsWithinTextField = true
    }
    
    
  
    

   
    
    
}
