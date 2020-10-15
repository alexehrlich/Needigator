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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
