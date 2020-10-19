//
//  AutomaticSearchTableTableViewCell.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 17.03.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit

protocol SearchTableViewCellDelegate{
    func getLeftProductCardArticle(article: Article, amount: Int)
    func getRightProductCardArticle(article: Article, amount: Int)
}

class SearchTableViewCell: UITableViewCell, DetailedProductSelectionViewControllerDelegate {

    
    func passUserSelection(amount: Int, action: UserInteraction, sender: DetailedProductSelectionViewController) {
        if action == .cancleAdding {
            UIView.transition(with: sender.view.superview!, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
            sender.view.removeFromSuperview()
            sender.removeFromParent()
        }else{
            if rightCardIsFlipped{
                delegate!.getRightProductCardArticle(article: rightCardArticle!, amount: amount)
                rightCardIsFlipped = false
            }else if leftCardIsFlipped{
                delegate!.getLeftProductCardArticle(article: leftCardArticle!, amount: amount)
                leftCardIsFlipped = false
            }
            UIView.transition(with: sender.view.superview!, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
            sender.view.removeFromSuperview()
            sender.removeFromParent()
        }
    }
    
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
    
    var flippedCard = UIView()
    
    var leftCardProductNode = 0
    var rightCardProductNode = 0
    var rightCardArticle : Article?
    var leftCardArticle: Article?
    
    var leftCardIsFlipped = false
    var rightCardIsFlipped = false
    
    var delegate: SearchTableViewCellDelegate?
    
    
    let leftDetailedProdSelectVC = DetailedProductSelectionViewController(nibName: "DetailedProductSelectionViewController", bundle: nil)
    let rightDetailedProdSelectVC = DetailedProductSelectionViewController(nibName: "DetailedProductSelectionViewController", bundle: nil)
    let rightCardFrontSideVC = FrontsideOfCardViewController(nibName: "FrontsideOfCardViewController", bundle: nil)
    let leftCardFrontSideVC = FrontsideOfCardViewController(nibName: "FrontsideOfCardViewController", bundle: nil)
    
    @IBOutlet weak var tableCellView: UIView!
    @IBOutlet weak var horizontalCardStackView: UIStackView!
    @IBOutlet weak var leftProductCardView: UIView!
    @IBOutlet weak var rightProductCardView: UIView!

    
    @IBOutlet weak var rightCellImage: UIImageView!
    @IBOutlet weak var rightProductLabel: UILabel!
    @IBOutlet weak var rightProductInformation: UILabel!
    @IBOutlet weak var rightProductPrice: UILabel!
    @IBOutlet weak var rightCardButton: UIButton!
    @IBOutlet weak var rightDataBackgroundView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.scrollViewWillBeginDragging), name: NavigationViewController.notificationNameForSearchTableVC, object: nil)
        
        leftCardFrontSideVC.view.bounds = rightProductCardView.bounds
        leftCardFrontSideVC.view.layer.cornerRadius = 10
        leftCardFrontSideVC.view.frame.origin = rightCardButton.frame.origin
        leftProductCardView.addSubview(leftCardFrontSideVC.view)
        
        
        self.leftDetailedProdSelectVC.userInteractionDelegate = self
        self.rightDetailedProdSelectVC.userInteractionDelegate = self
        
        leftProductCardView.layer.cornerRadius = 10
        leftProductCardView.layer.shadowColor = UIColor.lightGray.cgColor
        leftProductCardView.layer.shadowOpacity = 0.2
        leftProductCardView.layer.shadowOffset = .zero
        leftProductCardView.layer.shadowRadius = 10
        
        rightProductCardView.layer.cornerRadius = 10
        rightProductCardView.layer.shadowColor = UIColor.lightGray.cgColor
        rightProductCardView.layer.shadowOpacity = 0.2
        rightProductCardView.layer.shadowOffset = .zero
        rightProductCardView.layer.shadowRadius = 10
        rightDataBackgroundView.layer.cornerRadius = 10
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)

           // Configure the view for the selected state
       }

    
    @IBAction func rightCardTouched(_ sender: UIButton) {
        rightCardIsFlipped = true
        rightDetailedProdSelectVC.view.bounds = rightProductCardView.bounds
        rightDetailedProdSelectVC.view.layer.cornerRadius = 10
        rightDetailedProdSelectVC.view.frame.origin = rightCardButton.frame.origin
        rightProductCardView.addSubview(rightDetailedProdSelectVC.view)
        rightDetailedProdSelectVC.productLabel.text = rightProductLabel.text
        rightDetailedProdSelectVC.amountCnt = 1
        UIView.transition(with: rightProductCardView, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        
    }
    
    func hideLastCard(){
        rightProductCardView.alpha = 0
        rightCardButton.isUserInteractionEnabled = false
    }
    
    @objc func scrollViewWillBeginDragging() {
        if rightCardIsFlipped{
            UIView.transition(with: rightDetailedProdSelectVC.view, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
        }
    }
}

   
    
    

