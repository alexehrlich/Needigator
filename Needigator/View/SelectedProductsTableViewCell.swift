//
//  SelectedProductsTableViewCell.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 14.10.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit

class SelectedProductsTableViewCell: UITableViewCell {

    @IBOutlet weak var productLabel: UILabel!
    
    @IBOutlet weak var amountOfProduct: UILabel!
    
    var dataToDisplay : (Article, Int)? {
        didSet {
            
            if dataToDisplay!.0.isOnOffer{
                productLabel.textColor = UIColor.red
            }else{
                productLabel.textColor = UIColor.black
            }
            productLabel.text = " \(dataToDisplay!.0.getName())"
          
            amountOfProduct.text = "\(dataToDisplay!.1)"
        }
    }
    
    
    @IBAction func increaseProductAmountButtonPressed(_ sender: UIButton) {

        
//        NotificationCenter.default.post(Notification(name: Messages.changeProductAmountinCardViewCell, object: nil, userInfo: ["data": dataToDisplay!]))
    }
    
    
    @IBAction func decreasePriductAmountButtonPressed(_ sender: UIButton) {
        
//        NotificationCenter.default.post(Notification(name: Messages.changeProductAmountinCardViewCell, object: nil, userInfo: ["data": dataToDisplay!]))
    }
}
