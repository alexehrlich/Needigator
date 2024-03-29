//
//  CardViewController.swift
//  CardViewAnimation
//
//  Created by Brian Advent on 26.10.18.
//  Copyright © 2018 Brian Advent. All rights reserved.
//

import UIKit

protocol CardViewControllerDelegate {
    func goToRouteVC()
}

class CardViewController: UIViewController{
    
    @IBOutlet weak var selctedProductsTableView: UITableView!
    @IBOutlet weak var headBar: UIView!
    @IBOutlet weak var dragBar: UIView!
    @IBOutlet weak var handleArea: UIView!
    @IBOutlet weak var dragBarLabel: UILabel!
    @IBOutlet weak var productCntLabel: UILabel!
    @IBOutlet weak var cardViewHeadingLabel: UILabel!
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    @IBOutlet weak var totalPriceLabelView: UIView!
    
    
    var tapIsWithinTextField = false
    var amountOfArticle = 0
    
    var delegate: CardViewControllerDelegate?
    
    
    
    override func viewDidLoad() {
        
        selctedProductsTableView.delegate = self
        selctedProductsTableView.dataSource = self
        selctedProductsTableView.tableFooterView = UIView()
        
        dragBar.layer.cornerRadius = dragBar.frame.size.height/2
        
        dragBar.layer.shadowColor = UIColor.black.cgColor
        
        totalPriceLabelView.layer.cornerRadius = 10
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateViewFromModel), name: Messages.updatedSelectedProductDB, object: nil)
        
        
        selctedProductsTableView.register(UINib(nibName: "SelectedProductsTableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableSelectedProductCell")
    }
    
    @objc func updateViewFromModel(){
        productCntLabel.text = "\(Shopping.shared.selectedProductsOfUser.count)"
        
        let priceString = String(format: "%.2f", Shopping.shared.totalPrice).replacingOccurrences(of: ".", with: ",")
        totalPriceLabel.text = "Gesamtkosten: \(priceString) €"
        
        selctedProductsTableView.reloadData()
    }
    
    @IBAction func goToRoutingVCButton(_ sender: UIButton) {
        delegate?.goToRouteVC()
    }
}

//TableView Set-Up
extension CardViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Shopping.shared.selectedProductsOfUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableSelectedProductCell")! as! SelectedProductsTableViewCell
        let keys = Array(Shopping.shared.selectedProductsOfUser.keys)
        let key = keys[indexPath.row] as Article
        cell.dataToDisplay = (key, Shopping.shared.selectedProductsOfUser[key]) as? (Article, Int)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let keys = Array(Shopping.shared.selectedProductsOfUser.keys)
            let key = keys[indexPath.row] as Article
            Shopping.shared.selectedProductsOfUser.removeValue(forKey: key)
            
        }
    }
}



