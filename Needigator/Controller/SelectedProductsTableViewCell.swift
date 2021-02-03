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
    @IBOutlet weak var productAmountLabel: UILabel!

    var dataToDisplay : (Article, Int)? {
        didSet{
            if dataToDisplay!.0.isOnOffer{
                productLabel.textColor = #colorLiteral(red: 0.9599878192, green: 0.4176035821, blue: 0.476115346, alpha: 1)
            }else{
                productLabel.textColor = UIColor.black
            }
            productLabel.text = " \(dataToDisplay!.0.getName())"
            
            productAmountLabel.text = "\(dataToDisplay!.1)"
        }
    }
    
    
    
    @IBAction func decreaseButtonPressed(_ sender: UIButton) {

        Shopping.shared.updateSelectedItemsInModel(for: dataToDisplay!.0, with: dataToDisplay!.1, with: Shopping.Modification.decrease)
    }
    
    @IBAction func increaseButtonPressed(_ sender: UIButton) {
        Shopping.shared.updateSelectedItemsInModel(for: dataToDisplay!.0, with: dataToDisplay!.1, with: Shopping.Modification.increase)
    }
}
