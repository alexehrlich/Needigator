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

class SearchTableViewCell: UITableViewCell, DetailedProductSelectionViewControllerDelegate, UIScrollViewDelegate {

    
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
            if newValue == true {
                rightProductCardView.alpha = 0
                rightCardButton.isUserInteractionEnabled = false
            }else {
                rightProductCardView.alpha = 1
                rightCardButton.isUserInteractionEnabled = true
            }
        }
    }
    

    var leftCardProductNode = 0
    var rightCardProductNode = 0
    var rightCardArticle : Article?
    var leftCardArticle: Article?
    
    var leftCardIsFlipped = false
    var rightCardIsFlipped = false
    
    var delegate: SearchTableViewCellDelegate?
    
    
    let leftDetailedProdSelectVC = DetailedProductSelectionViewController(nibName: "DetailedProductSelectionViewController", bundle: nil)
    let rightDetailedProdSelectVC = DetailedProductSelectionViewController(nibName: "DetailedProductSelectionViewController", bundle: nil)
    
    @IBOutlet weak var tableCellView: UIView!
    @IBOutlet weak var horizontalCardStackView: UIStackView!
    @IBOutlet weak var leftProductCardView: UIView!
    @IBOutlet weak var rightProductCardView: UIView!
    
    
    @IBOutlet weak var leftCellImage: UIImageView!
    @IBOutlet weak var leftProductLabel: UILabel!
    @IBOutlet weak var leftProductInformation: UILabel!
    @IBOutlet weak var leftProductPrice: UILabel!
    @IBOutlet weak var leftCardButton: UIButton!
    @IBOutlet weak var leftDataBackgroundView: UIView!
    
    @IBOutlet weak var rightCellImage: UIImageView!
    @IBOutlet weak var rightProductLabel: UILabel!
    @IBOutlet weak var rightProductInformation: UILabel!
    @IBOutlet weak var rightProductPrice: UILabel!
    @IBOutlet weak var rightCardButton: UIButton!
    @IBOutlet weak var rightDataBackgroundView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.scrollViewWillBeginDragging), name: Messages.notificationNameForSearchTableVC, object: nil)
        
        self.leftDetailedProdSelectVC.userInteractionDelegate = self
        self.rightDetailedProdSelectVC.userInteractionDelegate = self
        
        leftProductCardView.layer.cornerRadius = 10
        leftProductCardView.layer.shadowColor = UIColor.lightGray.cgColor
        leftProductCardView.layer.shadowOpacity = 0.5
        leftProductCardView.layer.shadowOffset = .zero
        leftProductCardView.layer.shadowRadius = 10
        
        leftDataBackgroundView.layer.cornerRadius = 10
        
        rightProductCardView.layer.cornerRadius = 10
        rightProductCardView.layer.shadowColor = UIColor.lightGray.cgColor
        rightProductCardView.layer.shadowOpacity = 0.5
        rightProductCardView.layer.shadowOffset = .zero
        rightProductCardView.layer.shadowRadius = 10
        rightDataBackgroundView.layer.cornerRadius = 10

    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)

           // Configure the view for the selected state
       }
    
    @IBAction func leftCardTouched(_ sender: UIButton) {
        
        NotificationCenter.default.post(Notification(name: Messages.notificationNameForTappedProductCard, object: nil, userInfo: ["cell" : self]))
        
        leftCardIsFlipped = true
        self.leftDetailedProdSelectVC.view.bounds = leftProductCardView.bounds
        self.leftDetailedProdSelectVC.view.layer.cornerRadius = 10
        self.leftDetailedProdSelectVC.view.frame.origin = leftCardButton.frame.origin
        self.leftProductCardView.addSubview(leftDetailedProdSelectVC.view)
        self.leftDetailedProdSelectVC.productLabel.text = leftProductLabel.text
        self.leftDetailedProdSelectVC.amountCnt = 1
        UIView.transition(with: leftProductCardView, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
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
        
        if leftCardIsFlipped {
            leftCardIsFlipped = false
            UIView.transition(with: leftProductCardView, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            leftDetailedProdSelectVC.removeFromParent()
            leftDetailedProdSelectVC.view.removeFromSuperview()
        }
        
        if rightCardIsFlipped {
            rightCardIsFlipped = false
            UIView.transition(with: rightProductCardView, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            rightDetailedProdSelectVC.removeFromParent()
            rightDetailedProdSelectVC.view.removeFromSuperview()
        }
    }
        
        
}
   
    
    

