//
//  CardViewController.swift
//  CardViewAnimation
//
//  Created by Brian Advent on 26.10.18.
//  Copyright © 2018 Brian Advent. All rights reserved.
//

import UIKit

protocol MarketSelectedProtocol {
    func marketHasBeenChoosen()
}

class CardViewController: UIViewController {
    
    
    @IBOutlet weak var handleArea: UIView!
    @IBOutlet weak var dragBar: UIView!
  
    @IBOutlet weak var getLocationView: UIView!
    
    @IBOutlet weak var myMarketButtonView: UIView!
    
    
    var delegate: MarketSelectedProtocol!
    
    override func viewDidLoad() {
        dragBar.layer.cornerRadius = dragBar.frame.size.height/2
        getLocationView.layer.cornerRadius = getLocationView.frame.size.height/2
       myMarketButtonView.layer.cornerRadius = myMarketButtonView.frame.size.height/2
    }
    
    @IBAction func myMarketButtonPressed(_ sender: UIButton) {
        delegate.marketHasBeenChoosen()
    }
    
    
}
