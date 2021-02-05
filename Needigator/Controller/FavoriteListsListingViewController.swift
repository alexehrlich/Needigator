//
//  FavoriteListsListingViewController.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 26.11.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit
import CoreData

class FavoriteListsListingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var productTableView: UITableView!
    
    @IBOutlet weak var goDirectlyToNavigationButtonOutlet: UIButton!
    @IBOutlet weak var addMoreProductsButtonOutlet: UIButton!
    @IBOutlet weak var deleteBarButtonOutlet: UIBarButtonItem!

    
    //MARK: - CoreData Code
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var parentList: FavoriteList?
    var favProducts = [Article : Int]()
    var allFavorizedItemsFromDB = [Item]()
    
    let userFeedBackVC = UserFeedBackWhileCalculationViewController(nibName: "UserFeedBackWhileCalculationViewController", bundle: nil)
    

    override func viewWillAppear(_ animated: Bool) {
        
        //Hole alle Produkte aus der DB
        let itemsRequest : NSFetchRequest<Item> = Item.fetchRequest()
        
        do{
            allFavorizedItemsFromDB = try context.fetch(itemsRequest)
        }catch{
            print(error)
        }
        
        for item in allFavorizedItemsFromDB{
                //Sehr unschön: momentan muss immer zwischen der Item-Class (DB) und der Article-Class (App) konvertiert werden.
            
            for list in item.lists!{
                
                if let convertedList = list as? FavoriteList{
                    
                    if convertedList == parentList{
                        let article = Article(imageFileName: item.imgFileName!)
                        favProducts[article] = Int(item.amount)
                    }
                }
            }
        }
        
        Shopping.shared.selectedProductsOfUser = favProducts
        
        
        navigationController?.isNavigationBarHidden = false
        userFeedBackVC.view.removeFromSuperview()

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        deleteBarButtonOutlet.tintColor = #colorLiteral(red: 0.9311223626, green: 0.4162247777, blue: 0.4690252542, alpha: 1)
        goDirectlyToNavigationButtonOutlet.layer.cornerRadius = goDirectlyToNavigationButtonOutlet.frame.size.height/2
        addMoreProductsButtonOutlet.layer.cornerRadius = addMoreProductsButtonOutlet.frame.size.height/2
        
        productTableView.delegate = self
        productTableView.dataSource = self
        productTableView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateViewFromModel), name: Messages.updatedSelectedProductDB, object: nil)
        
        title = parentList?.name
        
        productTableView.register(UINib(nibName: "SelectedProductsTableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableSelectedProductCell")
    }
    
    @objc func updateViewFromModel(){
        productTableView.reloadData()
    }
    
    @IBAction func deleteButtonItem(_ sender: UIBarButtonItem) {
        //Delete from DB
        
        NotificationCenter.default.post(name: Messages.deleteFavoriteList, object: nil)
        navigationController?.popViewController(animated: true)
    }
    

    
    @IBAction func startNavigationDirectlyButtonPressed(_ sender: UIButton) {
        if Shopping.shared.selectedProductsOfUser.isEmpty{
            let alertController = UIAlertController(title: "Deine Einkaufsliste ist leer!", message:
                "Für die Routenberechnung muss sich mindestens 1 Artikel im Warenkorb befinden.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertController, animated: true, completion: nil)
            
        }else{
            
            userFeedBackVC.view.frame = self.view.frame
            userFeedBackVC.view.alpha = 0
            self.view.addSubview(userFeedBackVC.view)
            UIView.animate(withDuration: 0.5) {
                self.userFeedBackVC.view.alpha = 1
            }
            
            navigationController?.isNavigationBarHidden = true
            
            let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (_) in
                self.performSegue(withIdentifier: "goToRouteVC", sender: self)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Shopping.shared.selectedProductsOfUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = productTableView.dequeueReusableCell(withIdentifier: "ReusableSelectedProductCell") as! SelectedProductsTableViewCell
        let keys = Array(Shopping.shared.selectedProductsOfUser.keys)
        let key = keys[indexPath.row] as Article
        
        cell.dataToDisplay = ((key, Shopping.shared.selectedProductsOfUser[key]) as! (Article, Int))
        cell.productLabel.textColor = .black
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 60
    }
    

}
