//
//  ListOfProductsInOneNodeViewController.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 01.12.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit

class ListOfProductsInOneNodeViewController: UIViewController{
    
    var nodeNumber = 0
    var productsAtCurrentNode = [(Article, Int)]()
    
    @IBOutlet weak var productsAtNodeTV: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        productsAtCurrentNode.removeAll()
        
        for (article, amount) in Shopping.selectedProductsOfUser {
            if article.getNode() == nodeNumber {
                productsAtCurrentNode.append((article, amount))
                
            }
        }
        productsAtNodeTV.reloadData()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        productsAtNodeTV.delegate = self
        productsAtNodeTV.dataSource = self
        
        productsAtNodeTV.tableFooterView = UIView()
        
        productsAtNodeTV.register(UINib(nibName: "ListedProductsInNodeTableViewCell", bundle: nil), forCellReuseIdentifier: "checkProductCell")
        self.view.layer.cornerRadius = 10
        self.view.clipsToBounds = true
        
    }
}

extension ListOfProductsInOneNodeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsAtCurrentNode.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = productsAtNodeTV.dequeueReusableCell(withIdentifier: "checkProductCell") as! ListedProductsInNodeTableViewCell
        
        cell.productLabel.text = "\(productsAtCurrentNode[indexPath.row].1)x \(productsAtCurrentNode[indexPath.row].0.getName())"
        cell.productString = productsAtCurrentNode[indexPath.row].0.getName()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
