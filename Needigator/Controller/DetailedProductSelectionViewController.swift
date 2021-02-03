//
//  DetailedProductSelectionViewController.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 16.10.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit


enum UserInteraction {
    case addProduct
    case cancleAdding
}


protocol DetailedProductSelectionViewControllerDelegate {
    func passUserSelection(amount: Int, action: UserInteraction, sender: DetailedProductSelectionViewController)
}

class DetailedProductSelectionViewController: UIViewController {
    
    
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    @IBOutlet weak var addButtonOutlet: UIButton!
    @IBOutlet weak var amountStackView: UIStackView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var productLabel: UILabel!
    
    let addProductFeedBackVC = ProductAddedFeedbackViewController()
    
    var amountCnt = 1 {
        didSet{
            amountLabel.text = "\(amountCnt)"
        }
    }
    var userInteractionDelegate: DetailedProductSelectionViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amountStackView.layer.cornerRadius = 10
        addButtonOutlet.layer.cornerRadius = addButtonOutlet.frame.size.height / 2
        
        cancelButtonOutlet.layer.cornerRadius = cancelButtonOutlet.frame.size.height / 2
        
        amountLabel.text = "\(amountCnt)"
    }
    
    @IBAction func plusButtonTapped(_ sender: UIButton) {
        amountCnt += 1
    }
    
    
    @IBAction func minusButtonTapped(_ sender: UIButton) {
        
        if amountCnt > 1 {
            amountCnt -= 1
        }
    }
    
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        
        NotificationCenter.default.post(Notification(name: Messages.addProductToList, object: nil, userInfo: nil))
        
        addProductFeedBackVC.view.frame = self.view.frame
        addProductFeedBackVC.view.alpha = 0
        self.addChild(addProductFeedBackVC)
        self.view.addSubview(addProductFeedBackVC.view)
        
        UIView.animate(withDuration: 0.2) {
            self.addProductFeedBackVC.view.alpha = 1
        }
        
        let _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_) in
            self.userInteractionDelegate?.passUserSelection(amount: self.amountCnt, action: .addProduct, sender: self)
            
            self.addProductFeedBackVC.removeFromParent()
            self.addProductFeedBackVC.view.removeFromSuperview()
        }
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        userInteractionDelegate?.passUserSelection(amount: 0, action: .cancleAdding, sender: self)
    }
}
