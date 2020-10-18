//
//  CardViewController.swift
//  CardViewAnimation
//
//  Created by Brian Advent on 26.10.18.
//  Copyright © 2018 Brian Advent. All rights reserved.
//

import UIKit


class CardViewController: UIViewController{

    @IBOutlet weak var selctedProductsTableView: UITableView!
    @IBOutlet weak var headBar: UIView!
    @IBOutlet weak var dragBar: UIView!
    @IBOutlet weak var handleArea: UIView!
    
    var tapIsWithinTextField = false
    var selectedArticles = [(String, Int)]()
    var amountOfArticle = 0
    
    
    override func viewDidLoad() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.printSome(notification:)), name: NavigationViewController.notificationName, object: nil)
       
        
        selctedProductsTableView.delegate = self
        selctedProductsTableView.dataSource = self
        selctedProductsTableView.tableFooterView = UIView()
        
        dragBar.layer.cornerRadius = dragBar.frame.size.height/2
        
        selctedProductsTableView.register(UINib(nibName: "SelectedProductsTableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableSelectedProductCell")
    }
    
    @objc func printSome(notification: Notification) {
        
        let article = notification.userInfo!["data"] as! String
        let amount = notification.userInfo!["amount"] as! Int

        
            selectedArticles.append((article, amount))
            selctedProductsTableView.reloadData()

    }
}

//TableView Set-Up
extension CardViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableSelectedProductCell")! as! SelectedProductsTableViewCell
        cell.dataToDisplay = (selectedArticles[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}


