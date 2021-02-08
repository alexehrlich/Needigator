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
        
        var favorizedArticles = [Item]()
        var favoriteLists = [FavoriteList]()
        
        if listNameEnterTextField.text == ""{
            //User Feedback
        }else{
            addingDelegate.userDidFinishAdding()
            
            //Lade die Listen aus der DB
            let listRequest: NSFetchRequest<FavoriteList> = FavoriteList.fetchRequest()
            listRequest.returnsObjectsAsFaults = false
            
            do{
                favoriteLists = try context.fetch(listRequest)
            }catch{
                print(error)
            }
            
            //Prüfe ob schon eine Liste mit diesem Namen vorhanden ist
            if favoriteLists.contains(where: { (list) -> Bool in
                list.name == listNameEnterTextField.text
            }){
                let alert = UIAlertController(title: nil, message: "Es existiert schon eine Liste mit diesem Namen.", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default) { (_) in
                    return
                }
                
                alert.addAction(alertAction)
                present(alert, animated: true, completion: nil)
                
                //Wenn vorhanden, dann verlasse die Funktion
                return
            }
                        
            let newList = FavoriteList(context: context)
            newList.name = listNameEnterTextField.text!
            newList.amount = Int16(Shopping.shared.selectedProductsOfUser.count)
            
            //Datum speichern
            let now = Date()
            let formatter = DateFormatter ()
            formatter.locale = Locale(identifier: "de_DE")
            formatter.dateFormat = "d. MMMM yyyy"
            newList.date = formatter.string(from: now)
            
            saveContext()
            
            
            //Hole alle favorisierten Produkte aus der DB. Dort gibt es jedes Produkt nur einmal.
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            request.returnsObjectsAsFaults = false
            
            do{
                favorizedArticles = try context.fetch(request)
            }catch{
                print(error)
            }
            
            
            //Gehe alle momenttan ausgewählten Produkte durch
            for (article, amount) in Shopping.shared.selectedProductsOfUser{

                let newArticle = Item(context: context)
                newArticle.name = article.getName()
                newArticle.amount = Int16(amount)
                newArticle.image = article.getImage().pngData()
                newArticle.isOnOffer = article.isOnOffer
                newArticle.node = Int16(article.getNode())
                newArticle.officialPrice = article.getOfficialPrice()
                newArticle.offerPrice = article.offerPrice
                newArticle.imgFileName = article.imageFileName
                
                //Relationship zur Loste herstellen
                newArticle.addToLists(newList)

                saveContext()
            }
            
            UIView.animate(withDuration: 0.8) {
                self.view.center = CGPoint(x: self.view.superview!.center.x, y: (self.view.superview?.frame.height)! + self.view.frame.height / 2)
            } completion: { (true) in
                self.view.removeFromSuperview()
                self.removeFromParent()
            }
        }
    }
    
    func saveContext(){
        do{
            try context.save()
        }catch{
            print("Error while saving context: \(error)")
        }
    }
    
    
    @IBAction func cancleListButtonPressed(_ sender: UIButton) {
        
        addingDelegate.userDidFinishAdding()
        
        UIView.animate(withDuration: 0.8) {
            self.view.center = CGPoint(x: self.view.superview!.center.x, y: (self.view.superview?.frame.height)! + self.view.frame.height / 2)
        } completion: { (true) in
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
    
}
