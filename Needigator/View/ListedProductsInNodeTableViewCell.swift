//
//  ListedProductsInNodeTableViewCell.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 01.12.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit

class ListedProductsInNodeTableViewCell: UITableViewCell {
    
    var productString = String()

    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var checkmarkImageView: UIImageView!
    @IBOutlet weak var cellColorBackgroundView: UIView!
    
    
    override func layoutSubviews() {
        
       cellColorBackgroundView.layer.cornerRadius = 10
        if Shopping.checkedProducts.contains(productString) == true {
            checkmarkImageView.image = UIImage(systemName: "checkmark.circle.fill")
            checkmarkImageView.tintColor = #colorLiteral(red: 0, green: 1, blue: 0.2120317221, alpha: 0.5980040668)
        }else{
            checkmarkImageView.image = UIImage(systemName: "circle")
            checkmarkImageView.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
    }
    
    @IBAction func checkButtonPressed(_ sender: UIButton) {
        
        if Shopping.checkedProducts.contains(productString) == false {
            Shopping.checkedProducts.insert(productString)
            checkmarkImageView.image = UIImage(systemName: "checkmark.circle.fill")
            checkmarkImageView.tintColor = #colorLiteral(red: 0, green: 1, blue: 0.2120317221, alpha: 0.5980040668)
        }else{
            Shopping.checkedProducts.remove(productString)
            checkmarkImageView.image = UIImage(systemName: "circle")
            checkmarkImageView.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
    }
}

