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

class SearchTableViewCell: UITableViewCell, UIScrollViewDelegate {
    
    var leftCardProductNode = 0
    var rightCardProductNode = 0
    var rightCardArticle : Article?
    var leftCardArticle: Article?
    
    var leftCardIsFlipped = false
    var rightCardIsFlipped = false
    
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
    
    var delegate: SearchTableViewCellDelegate?
    
    
    let leftDetailedProdSelectVC = DetailedProductSelectionViewController(nibName: "DetailedProductSelectionViewController", bundle: nil)
    let rightDetailedProdSelectVC = DetailedProductSelectionViewController(nibName: "DetailedProductSelectionViewController", bundle: nil)
    
    let leftAlreadySelectedViewVC = AlreadySelectedViewController(nibName: "AlreadySelectedViewController", bundle: nil)
    let rightAlreadySelectedViewVC = AlreadySelectedViewController(nibName: "AlreadySelectedViewController", bundle: nil)
    
    
    
    @IBOutlet weak var tableCellView: UIView!
    @IBOutlet weak var horizontalCardStackView: UIStackView!
    @IBOutlet weak var leftProductCardView: UIView!
    @IBOutlet weak var rightProductCardView: UIView!
    
    
    @IBOutlet weak var leftCellImage: UIImageView!
    @IBOutlet weak var leftProductLabel: UILabel!
    @IBOutlet weak var leftProductAmount: UILabel!
    @IBOutlet weak var leftProductPrice: UILabel!
    @IBOutlet weak var leftCardButton: UIButton!
    @IBOutlet weak var leftDataBackgroundView: UIView!
    @IBOutlet weak var leftOfferView: UIView!
    @IBOutlet weak var leftOfferPriceLabel: UILabel!
    
    @IBOutlet weak var leftOfferPriceBackgroundView: UIView!
    @IBOutlet weak var leftProductCheckmark: UIImageView!
    
    
    @IBOutlet weak var rightCellImage: UIImageView!
    @IBOutlet weak var rightProductLabel: UILabel!
    @IBOutlet weak var rightProductAmount: UILabel!
    @IBOutlet weak var rightProductPrice: UILabel!
    @IBOutlet weak var rightCardButton: UIButton!
    @IBOutlet weak var rightDataBackgroundView: UIView!
    @IBOutlet weak var rightOfferView: UIView!
    @IBOutlet weak var rightOfferPriceLabel: UILabel!
    
    @IBOutlet weak var rightOfferPriceBackgroundView: UIView!
    @IBOutlet weak var rightProductCheckmark: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        leftProductCheckmark.alpha = 0
        rightProductCheckmark.alpha = 0
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.scrollViewWillBeginDragging), name: Messages.notificationNameForSearchTableVC, object: nil)
        
        self.leftDetailedProdSelectVC.userInteractionDelegate = self
        self.rightDetailedProdSelectVC.userInteractionDelegate = self
        
        self.leftAlreadySelectedViewVC.delegate = self
        self.rightAlreadySelectedViewVC.delegate = self
        
        leftProductCardView.layer.cornerRadius = 10
        leftProductCardView.layer.shadowColor = UIColor.lightGray.cgColor
        leftProductCardView.layer.shadowOpacity = 0.5
        leftProductCardView.layer.shadowOffset = .zero
        leftProductCardView.layer.shadowRadius = 10
        
        leftDataBackgroundView.layer.cornerRadius = 10
        leftOfferPriceBackgroundView.layer.cornerRadius = 10
        
        rightProductCardView.layer.cornerRadius = 10
        rightProductCardView.layer.shadowColor = UIColor.lightGray.cgColor
        rightProductCardView.layer.shadowOpacity = 0.5
        rightProductCardView.layer.shadowOffset = .zero
        rightProductCardView.layer.shadowRadius = 10
        rightDataBackgroundView.layer.cornerRadius = 10
        rightOfferPriceBackgroundView.layer.cornerRadius = 10
        
    }
    
    
    @IBAction func leftCardTouched(_ sender: UIButton) {
        
        
        NotificationCenter.default.post(Notification(name: Messages.notificationNameForTappedProductCard, object: nil, userInfo: nil))
        
        //Produkt noch nciht ausgewählt, also zeige die Rückseite zum Auswählen
        if Shopping.shared.selectedProductsOfUser[leftCardArticle!] == nil {
            leftCardIsFlipped = true
            leftDetailedProdSelectVC.view.frame = leftProductCardView.frame
            leftDetailedProdSelectVC.view.layer.cornerRadius = 10
            leftDetailedProdSelectVC.view.frame.origin = leftCardButton.frame.origin
            leftProductCardView.addSubview(leftDetailedProdSelectVC.view)
            leftDetailedProdSelectVC.productLabel.text = leftProductLabel.text
            
            if Shopping.shared.selectedProductsOfUser[leftCardArticle!] == nil {
                leftDetailedProdSelectVC.amountCnt = 1
            }else{
                leftDetailedProdSelectVC.amountCnt = Shopping.shared.selectedProductsOfUser[leftCardArticle!]!
            }
            
            UIView.transition(with: leftProductCardView, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        }else{
            //Produkt schon ausgewählt, also anderen Screen anzeigen
            leftCardIsFlipped = true
            leftAlreadySelectedViewVC.view.frame = leftProductCardView.frame
            leftAlreadySelectedViewVC.view.layer.cornerRadius = 10
            leftAlreadySelectedViewVC.view.frame.origin = leftCardButton.frame.origin
            leftProductCardView.addSubview(leftAlreadySelectedViewVC.view)
            
            UIView.transition(with: leftProductCardView, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        }
    }
    
    @IBAction func rightCardTouched(_ sender: UIButton) {
        
        
        
        NotificationCenter.default.post(Notification(name: Messages.notificationNameForTappedProductCard, object: nil, userInfo: nil))
        
        if Shopping.shared.selectedProductsOfUser[rightCardArticle!] == nil {
            rightCardIsFlipped = true
            rightDetailedProdSelectVC.view.frame = rightProductCardView.frame
            rightDetailedProdSelectVC.view.layer.cornerRadius = 10
            rightDetailedProdSelectVC.view.frame.origin = rightCardButton.frame.origin
            rightProductCardView.addSubview(rightDetailedProdSelectVC.view)
            rightDetailedProdSelectVC.productLabel.text = rightProductLabel.text
            
            if Shopping.shared.selectedProductsOfUser[rightCardArticle!] == nil {
                rightDetailedProdSelectVC.amountCnt = 1
            }else{
                rightDetailedProdSelectVC.amountCnt = Shopping.shared.selectedProductsOfUser[rightCardArticle!]!
            }
            
            UIView.transition(with: rightProductCardView, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        }else {
            //Produkt schon ausgewählt, also anderen Screen anzeigen
            
            rightCardIsFlipped = true
            rightAlreadySelectedViewVC.view.frame = rightProductCardView.frame
            rightAlreadySelectedViewVC.view.layer.cornerRadius = 10
            rightAlreadySelectedViewVC.view.frame.origin = rightCardButton.frame.origin
            rightProductCardView.addSubview(rightAlreadySelectedViewVC.view)
            
            UIView.transition(with: rightProductCardView, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        }
        
    }
    
    
    func hideLastCard(){
        rightProductCardView.alpha = 0
        rightCardButton.isUserInteractionEnabled = false
    }
    
    @objc func scrollViewWillBeginDragging() {
        
        if leftCardIsFlipped {
            leftCardIsFlipped = false
            UIView.transition(with: leftProductCardView, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            leftAlreadySelectedViewVC.view.removeFromSuperview()
            leftAlreadySelectedViewVC.removeFromParent()
            leftDetailedProdSelectVC.removeFromParent()
            leftDetailedProdSelectVC.view.removeFromSuperview()
        }
        
        if rightCardIsFlipped {
            rightCardIsFlipped = false
            UIView.transition(with: rightProductCardView, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            rightAlreadySelectedViewVC.view.removeFromSuperview()
            rightAlreadySelectedViewVC.removeFromParent()
            rightDetailedProdSelectVC.removeFromParent()
            rightDetailedProdSelectVC.view.removeFromSuperview()
        }
    }
}


//MARK: Delagate - Kommunikation zwischen der geflippten Kundenauswahl und der TableCell
extension SearchTableViewCell: DetailedProductSelectionViewControllerDelegate{
    
    func passUserSelection(amount: Int, action: UserInteraction, sender: DetailedProductSelectionViewController) {
        if action == .cancleAdding {
            
            if rightCardIsFlipped{
                rightCardIsFlipped = !rightCardIsFlipped
            }
            
            if leftCardIsFlipped{
                leftCardIsFlipped = !leftCardIsFlipped
            }
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
}

extension SearchTableViewCell: AlreradySelectedViewControllerDelegate{
    func passUserSelectionFromAlreaySelectedVC(selection: Bool, sender: AlreadySelectedViewController) {
        
        //Okay pressed
        if selection == true {
            if rightCardIsFlipped{
                rightCardIsFlipped = !rightCardIsFlipped
            }
            
            if leftCardIsFlipped{
                leftCardIsFlipped = !leftCardIsFlipped
            }
            UIView.transition(with: sender.view.superview!, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
            sender.view.removeFromSuperview()
            sender.removeFromParent()
        }else{
            if rightCardIsFlipped{
                Shopping.shared.selectedProductsOfUser.removeValue(forKey: rightCardArticle!)
                rightCardIsFlipped = false
            }else if leftCardIsFlipped{
                Shopping.shared.selectedProductsOfUser.removeValue(forKey: leftCardArticle!)
                leftCardIsFlipped = false
            }
            
            UIView.transition(with: sender.view.superview!, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
            sender.view.removeFromSuperview()
            sender.removeFromParent()
        }
    }
}





