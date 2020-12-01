//
//  ListedProductsInNodeTableViewCell.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 01.12.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit

class ListedProductsInNodeTableViewCell: UITableViewCell {


    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var checkmarkImageView: UIImageView!
    
    
    var productIsChecked = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func checkButtonPressed(_ sender: UIButton) {
        
        productIsChecked = !productIsChecked
        
        if productIsChecked == false {
            checkmarkImageView.image = UIImage(systemName: "circle")
            checkmarkImageView.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }else{
            checkmarkImageView.image = UIImage(systemName: "checkmark.circle.fill")
            checkmarkImageView.tintColor = #colorLiteral(red: 0, green: 1, blue: 0.2120317221, alpha: 0.5418450342)
        }
    }
}
