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
    @IBOutlet weak var goToMarketButton: UIButton!
    
    var delegate: MarketSelectedProtocol!
    
    override func viewDidLoad() {
        dragBar.layer.cornerRadius = dragBar.frame.size.height/2
        goToMarketButton.layer.cornerRadius = 12
    }
    
    
    @IBAction func visitSelectedMarket(_ sender: UIButton) {
        delegate.marketHasBeenChoosen()
    }
    
    
}
