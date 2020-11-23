//
//  AngebotViewController.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 16.03.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit

class ShoppingListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
    

    @IBOutlet weak var tableViewOfFavoriteShoppingLists: UITableView!
    
    @IBOutlet weak var listCellLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Deine Einkaufslisten"
        print(Shopping.favoriteShoppingLists.count)
        
        
        tableViewOfFavoriteShoppingLists.delegate = self
        tableViewOfFavoriteShoppingLists.dataSource = self
        tableViewOfFavoriteShoppingLists.register(UINib(nibName: "FavoriteShoppingListTableViewCell", bundle: nil), forCellReuseIdentifier: "ShoppingListCell")
        tableViewOfFavoriteShoppingLists.reloadData()
        

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Shopping.favoriteShoppingLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListCell") as! FavoriteShoppingListTableViewCell
        let keys = Array(Shopping.favoriteShoppingLists.keys)
        let key = keys[indexPath.row] as String
        
        cell.amountOfProductsInListLabel.text = String(Shopping.favoriteShoppingLists[key]!.count)
        cell.listNameLabel.text = String(key)
        
        cell.cellBackgroundView.center = cell.contentView.center
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    

}
