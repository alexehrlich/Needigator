//
//  AutomaticSearchTableTableViewCell.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 17.03.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit

// Only class object can conform to this protocol (struct/enum can't)
protocol AutomaticSearchTableTableViewCellDelegate: AnyObject {
  func automaticSearchTableTableViewCell(_ automaticSearchTableTableViewCell: AutomaticSearchTableTableViewCell, articleName item: Int)
}

class AutomaticSearchTableTableViewCell: UITableViewCell {


    
    var articleNodeNumber: Int?
    var amountOfItem: Int = 0
    
    // the delegate, remember to set to weak to prevent cycles
    weak var delegate : AutomaticSearchTableTableViewCellDelegate?
    
    @IBOutlet weak var tableCellView: UIView!
    @IBOutlet weak var horizontalCardStackView: UIStackView!
    @IBOutlet weak var leftProductCardView: UIView!
    @IBOutlet weak var rightProductCardView: UIView!
    
    
    @IBOutlet weak var leftCellImage: UIImageView!
    @IBOutlet weak var leftProductLabel: UILabel!
    @IBOutlet weak var leftProductInformation: UILabel!
    @IBOutlet weak var leftProductPrice: UILabel!
    
    
    @IBOutlet weak var rightCellImage: UIImageView!
    @IBOutlet weak var rightProductLabel: UILabel!
    @IBOutlet weak var rightProductInformation: UILabel!
    @IBOutlet weak var rightProductPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.frame.size.height = 10
        
        leftProductCardView.layer.cornerRadius = 5
        rightProductCardView.layer.cornerRadius = 5
   
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)

           // Configure the view for the selected state
       }
}

   
    
    

