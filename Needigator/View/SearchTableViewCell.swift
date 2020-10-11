//
//  AutomaticSearchTableTableViewCell.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 17.03.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit

protocol SearchTableViewCellDelegate{
    func getNodeNumberOfLeftProductCard(number: Int)
    func getNodeNumberOfRightProductCard(number: Int)
}

class SearchTableViewCell: UITableViewCell {

    var onlyOneProductCard: Bool = false{
        willSet(newValue){
            print(newValue)
            if newValue == true {
                rightProductCardView.alpha = 0
                rightCardButton.isUserInteractionEnabled = false
            }else {
                rightProductCardView.alpha = 1
                rightCardButton.isUserInteractionEnabled = true
            }
        }
    }
    
    var rightCardProductNode = 0
    var leftCardProductNode = 0
    
    var delegate: SearchTableViewCellDelegate?

    @IBOutlet weak var tableCellView: UIView!
    @IBOutlet weak var horizontalCardStackView: UIStackView!
    @IBOutlet weak var leftProductCardView: UIView!
    @IBOutlet weak var rightProductCardView: UIView!
    
    
    @IBOutlet weak var leftCellImage: UIImageView!
    @IBOutlet weak var leftProductLabel: UILabel!
    @IBOutlet weak var leftProductInformation: UILabel!
    @IBOutlet weak var leftProductPrice: UILabel!
    @IBOutlet weak var leftCardButton: UIButton!
    
    
    @IBOutlet weak var rightCellImage: UIImageView!
    @IBOutlet weak var rightProductLabel: UILabel!
    @IBOutlet weak var rightProductInformation: UILabel!
    @IBOutlet weak var rightProductPrice: UILabel!
    @IBOutlet weak var rightCardButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.frame.size.height = 10
        
        leftProductCardView.layer.cornerRadius = 5
        leftCardButton.layer.cornerRadius = 3
        
        rightProductCardView.layer.cornerRadius = 5
        rightCardButton.layer.cornerRadius = 3
        
        
        leftProductLabel.sizeToFit()
   
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)

           // Configure the view for the selected state
       }
    
    @IBAction func leftCardTouched(_ sender: UIButton) {
        delegate!.getNodeNumberOfLeftProductCard(number: leftCardProductNode)
    }
    
    @IBAction func rightCardTouched(_ sender: UIButton) {
        delegate!.getNodeNumberOfRightProductCard(number: rightCardProductNode)
    }
    
    func hideLastCard(){
        rightProductCardView.alpha = 0
        rightCardButton.isUserInteractionEnabled = false
    }
   
}

   
    
    

