//
//  ColorLegendViewController.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 20.11.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit

class RouteVCShoppingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var shoppingListTableView: UITableView!
    
    var sortedNodeList = [Node]()
    var sortedSelectedProductList = [Article]()
    
    override func viewWillAppear(_ animated: Bool) {
        
        for node in sortedNodeList{
            for product in Shopping.selectedProductsOfUser{
                if product.key.getNode() == node.getNodeName(){
                    sortedSelectedProductList.append(product.key)
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shoppingListTableView.delegate = self
        shoppingListTableView.dataSource = self
        
        shoppingListTableView.register(UINib(nibName: "ListedProductsInNodeTableViewCell", bundle: nil), forCellReuseIdentifier: "checkProductCell")
        
        shoppingListTableView.tableFooterView = UIView()
        shoppingListTableView.separatorStyle = .none
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedSelectedProductList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = shoppingListTableView.dequeueReusableCell(withIdentifier: "checkProductCell") as! ListedProductsInNodeTableViewCell

        let key = sortedSelectedProductList[indexPath.row]
        cell.productLabel.text = "\(Shopping.selectedProductsOfUser[key]!)x \(key.getName())"
        cell.productString = key.getName()
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
