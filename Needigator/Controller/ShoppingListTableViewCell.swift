//
//  ShoppingListTableViewCell.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 26.11.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit

protocol ShoppingListTableViewCellDelegate {
    func callSegueFromCell(for list: FavoriteList)
}

class ShoppingListTableViewCell: UITableViewCell {

    @IBOutlet weak var cellBackground: UIView!
    @IBOutlet weak var listNameLabel: UILabel!
    @IBOutlet weak var productAmountLabel: UILabel!
    @IBOutlet weak var dateOfShoppingLabel: UILabel!
    
    @IBOutlet weak var widthConstraintBackgroundView: NSLayoutConstraint!
    
    var cellDelgate: ShoppingListTableViewCellDelegate!
    
    var list: FavoriteList?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellBackground.layer.cornerRadius = 10
    }

    
    @IBAction func goToListButtonPressed(_ sender: UIButton) {
        cellDelgate.callSegueFromCell(for: list!)
    }
    
}
