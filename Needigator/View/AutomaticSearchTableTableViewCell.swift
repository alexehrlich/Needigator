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

    
        
//    @IBOutlet weak var clearBackgroundView: UIView!
    
    
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleNameOutlet: UILabel!
    @IBOutlet weak var articleInfoOutlet: UILabel!
    @IBOutlet weak var articlePriceOutlet: UILabel!
    @IBOutlet weak var backgroundImageView: UIView!
    @IBOutlet weak var addToRouteButtonBackground: UIView!
    @IBOutlet weak var amountItemLabel: UILabel!
    
    
    var articleNodeNumber: Int?
    var amountOfItem: Int = 0
    
    // the delegate, remember to set to weak to prevent cycles
    weak var delegate : AutomaticSearchTableTableViewCellDelegate?
    
    @IBOutlet weak var tableCellView: UIView!
    
    @IBOutlet weak var addButtonOutlet: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addToRouteButtonBackground.layer.cornerRadius = 10
        
        
        //backgroundImageView.frame.size.height = 90
        self.addButtonOutlet.addTarget(self, action: #selector(addToRouteButtonPressed(_:)), for: .touchUpInside)
        }
    override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)

           // Configure the view for the selected state
       }
       
      
    @IBAction func addToRouteButtonPressed(_ sender: UIButton) {
          delegate?.automaticSearchTableTableViewCell(self, articleName: articleNodeNumber!)
    }
    
   
    @IBAction func increaseItemButtonPressed(_ sender: UIButton) {
        amountOfItem += 1
        amountItemLabel.text = String(amountOfItem)
    }
    
    
    @IBAction func decreaseItemButtonPressed(_ sender: UIButton) {
        
        if amountOfItem > 0 {
            amountOfItem -= 1
            amountItemLabel.text = String(amountOfItem)
        }
        
    }
}

   
    
    

