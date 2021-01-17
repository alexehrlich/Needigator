//
//  AngebotViewController.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 16.03.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit

class ShoppingListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ShoppingListTableViewCellDelegate {
    

    @IBOutlet weak var tableViewOfFavoriteShoppingLists: UITableView!
    
    
    var lastCellTapped = String()
    
    override func viewWillAppear(_ animated: Bool) {
        tableViewOfFavoriteShoppingLists.reloadData()
        
        showUserPromptIfNeeded()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Deine Einkaufslisten"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        
        tableViewOfFavoriteShoppingLists.delegate = self
        tableViewOfFavoriteShoppingLists.dataSource = self
        tableViewOfFavoriteShoppingLists.register(UINib(nibName: "ShoppingListTableViewCell", bundle: nil), forCellReuseIdentifier: "ShoppingListCell")
    }
    
    func showUserPromptIfNeeded(){
        if Shopping.favoriteShoppingLists.isEmpty{
            
            let userPromptLabel = UILabel(frame: CGRect(origin: self.view.frame.origin, size: self.view.frame.size))
            
            userPromptLabel.textAlignment = .center
            
            let font = UIFont(name: "Helvetica Neue", size: 30)
            userPromptLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            userPromptLabel.numberOfLines = 0
            userPromptLabel.font = font
            userPromptLabel.text = "Du hast noch keine favorisierten Listen."
            self.view.addSubview(userPromptLabel)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Shopping.favoriteShoppingLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListCell") as! ShoppingListTableViewCell
        let keys = Array(Shopping.favoriteShoppingLists.keys).sorted()
        let key = keys[indexPath.row] as String
        
        cell.productAmountLabel.text = String(Shopping.favoriteShoppingLists[key]!.count)
        cell.listNameLabel.text = String(key)
        
        //Datum schreiben:
        let now = Date()
        let formatter = DateFormatter ()
        formatter.locale = Locale(identifier: "de_DE")
        formatter.dateFormat = "d. MMMM yyyy"
        cell.dateOfShoppingLabel.text = formatter.string(from: now)
        
        
        cell.widthConstraintBackgroundView.constant = self.view.frame.size.width * 0.9
        
        cell.cellDelgate = self

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 120
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let keys = Array(Shopping.favoriteShoppingLists.keys).sorted()
            let key = keys[indexPath.row] as String
            print(indexPath.row)
            print(key)
            Shopping.favoriteShoppingLists.removeValue(forKey: key)
            tableViewOfFavoriteShoppingLists.reloadData()
            showUserPromptIfNeeded()
        }
    }
    
    func callSegueFromCell(date: String) {
        
        lastCellTapped = String(date)
        
        performSegue(withIdentifier: "goToListingsVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToListingsVC" {
            
            let destVC = segue.destination as! FavoriteListsListingViewController
            destVC.list = lastCellTapped
        }
    }
}
