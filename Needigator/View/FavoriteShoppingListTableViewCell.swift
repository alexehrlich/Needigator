//
//  FavoriteShoppingListTableViewCell.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 23.11.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit

class FavoriteShoppingListTableViewCell: UITableViewCell {

    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var listNameLabel: UILabel!
    @IBOutlet weak var amountOfProductsInListLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellBackgroundView.layer.cornerRadius = 12
    }
}
