//
//  AddListToFavoritesViewController.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 23.11.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit
import CoreData

protocol AddListToFavoritesViewControllerDelegate {
    func userDidFinishAdding()
}

class AddListToFavoritesViewController: UIViewController {
    
    @IBOutlet weak var listNameEnterTextField: UITextField!
    @IBOutlet weak var textFieldView: UIView!
    @IBOutlet weak var addListButtonOutlet: UIButton!
    @IBOutlet weak var cancleButtonOutlet: UIButton!
    
    var addingDelegate: AddListToFavoritesViewControllerDelegate!
    
    //MARK: CoreData Code
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldView.layer.cornerRadius = textFieldView.frame.size.height/2
        
        addListButtonOutlet.layer.cornerRadius = addListButtonOutlet.frame.size.height/2
        
        cancleButtonOutlet.layer.cornerRadius = cancleButtonOutlet.layer.frame.size.height/2
    }
    
    @IBAction func addListButtonPressed(_ sender: UIButton) {
        
        if listNameEnterTextField.text == ""{
            //User Feedback
        }else{
            addingDelegate.userDidFinishAdding()

            //Add List to Model
//            Shopping.shared.favoriteShoppingLists[listNameEnterTextField.text!] = Shopping.shared.selectedProductsOfUser
            
            let newList = FavoriteList(context: context)
            newList.name = listNameEnterTextField.text!
            
            for (article, amount) in Shopping.shared.selectedProductsOfUser{
                
                let newArticle = Item(context: context)
                newArticle.name = article.getName()
                newArticle.amount = Int16(amount)
                newArticle.image = article.getImage().pngData()
                newArticle.isOnOffer = article.isOnOffer
                newArticle.node = Int16(article.getNode())
                newArticle.officialPrice = article.getOfficialPrice()
                newArticle.offerPrice = article.offerPrice
                
                newArticle.addToLists(newList)
                
                do{
                    try context.save()
                }catch{
                    print("Error while saving context: \(error)")
                }
            }
            
            
            UIView.animate(withDuration: 0.8) {
                self.view.frame.origin = CGPoint(x: 60, y: (self.view.superview?.frame.height)!)
            } completion: { (true) in
                self.view.removeFromSuperview()
                self.removeFromParent()
            }
        }
    }
    
    
    @IBAction func cancleListButtonPressed(_ sender: UIButton) {
        
        addingDelegate.userDidFinishAdding()
        
        UIView.animate(withDuration: 0.8) {
            self.view.frame.origin = CGPoint(x: 60, y: (self.view.superview?.frame.height)!)
        } completion: { (true) in
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
    
}
