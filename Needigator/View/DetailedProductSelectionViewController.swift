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
    
    var amountCnt = 1 {
        didSet{
            amountLabel.text = "\(amountCnt)"
        }
    }
    var userInteractionDelegate: DetailedProductSelectionViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.scrollViewWillBeginDragging), name: Messages.notificationNameForSearchTableVC, object: nil)
        
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
        userInteractionDelegate?.passUserSelection(amount: amountCnt, action: .addProduct, sender: self)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        userInteractionDelegate?.passUserSelection(amount: 0, action: .cancleAdding, sender: self)
    }
    
    @objc func scrollViewWillBeginDragging() {
       // self.removeFromParent()
       // self.view.removeFromSuperview()
    }
    
    
    
    
}
