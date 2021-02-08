//
//  AngebotViewController.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 16.03.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit
import CoreData

class ShoppingListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ShoppingListTableViewCellDelegate {
    
    
    @IBOutlet weak var tableViewOfFavoriteShoppingLists: UITableView!
    
    //MARK: CoreData
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var favoriteLists = [FavoriteList]()
    
    var chosenList : FavoriteList?
    var lastTappedRow = 0
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        loadLists()
        showUserPromptIfNeeded()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(deleteList), name: Messages.deleteFavoriteList, object: nil)

        self.title = "Deine Einkaufslisten"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        
        tableViewOfFavoriteShoppingLists.delegate = self
        tableViewOfFavoriteShoppingLists.dataSource = self
        tableViewOfFavoriteShoppingLists.register(UINib(nibName: "ShoppingListTableViewCell", bundle: nil), forCellReuseIdentifier: "ShoppingListCell")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Shopping.shared.selectedProductsOfUser.removeAll()
    }
    
    func showUserPromptIfNeeded(){
        if favoriteLists.isEmpty{
            
            let userPromptLabel = UILabel(frame: CGRect(origin: self.view.frame.origin, size: self.view.frame.size))
            
            userPromptLabel.textAlignment = .center
            
            let font = UIFont(name: "Helvetica Neue", size: 20)
            userPromptLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            userPromptLabel.numberOfLines = 0
            userPromptLabel.font = font
            userPromptLabel.text = "Du hast noch keine favorisierten Listen."
            self.view.addSubview(userPromptLabel)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListCell") as! ShoppingListTableViewCell
        
        let currentElement = favoriteLists[indexPath.row]
        
        cell.productAmountLabel.text = String(currentElement.amount)
        cell.listNameLabel.text = currentElement.name
        cell.dateOfShoppingLabel.text = currentElement.date
        cell.productAmountLabel.text = String(currentElement.amount)
        cell.widthConstraintBackgroundView.constant = self.view.frame.size.width * 0.9
        cell.list = currentElement
        cell.cellDelgate = self

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 120
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            let cell = tableView.cellForRow(at: indexPath) as! ShoppingListTableViewCell
            
            let favoriteList = cell.list
            
            context.delete(favoriteList!)
            loadLists()
            
            saveContext()
           
            tableViewOfFavoriteShoppingLists.reloadData()
            showUserPromptIfNeeded()
        }
    }
    
    func saveContext(){
        do{
            try context.save()
        }catch{
            print("Error while saving context: \(error)")
        }
    }
    
    
    func callSegueFromCell(for list: FavoriteList) {
        chosenList = list
        performSegue(withIdentifier: "goToListingsVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToListingsVC" {
            
            let destVC = segue.destination as! FavoriteListsListingViewController
            destVC.parentList = chosenList
        }
    }
    
    @objc func deleteList(notification: Notification){
        
        //Get the list from
        if let userInfo = notification.userInfo as? [String: FavoriteList] 
        {
            context.delete(userInfo["list"]!)
            tableViewOfFavoriteShoppingLists.reloadData()
        }
    }
    
    func loadLists(){
        //Hole alle Listen aus der SQLite-DB
        
        let listRequest: NSFetchRequest<FavoriteList> = FavoriteList.fetchRequest()
        
        do{
            favoriteLists = try context.fetch(listRequest)
        }catch{
            print(error)
        }
        
        tableViewOfFavoriteShoppingLists.reloadData()
    }
}
