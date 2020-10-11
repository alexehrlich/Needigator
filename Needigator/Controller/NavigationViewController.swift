//
//  NavigationViewController.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 16.03.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit

class NavigationViewController: UIViewController, UITableViewDelegate, SearchTableViewCellDelegate{
    func getNodeNumberOfLeftProductCard(number: Int) {
        selectedItems.append(number)
    }
    
    func getNodeNumberOfRightProductCard(number: Int) {
        selectedItems.append(number)
    }
    
    

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var articleTableView: UITableView!
    @IBOutlet weak var productTypeSegmentedControl: UISegmentedControl!
    
    
    @IBOutlet weak var navigationButtonBackgroundView: UIView!
    @IBOutlet weak var cartButtonOutlet: UIButton!
    @IBOutlet weak var amountItemsOutlet: UILabel!
    
   var amountOfItems = 0
    
    
    let articleDataBase = ArticleDataBase()
    
    var substringArticles = [Article]()
    
    var selectedItems = [Int]()
    
    var selectedArticles = [String]()
    
    var navigation = Navigation()
    
    //Wenn der Bildschirm auftaucht wenn man wieder zu diesem zurückkehrt, dann soll alles gelöscht sein.
    override func viewWillAppear(_ animated: Bool){
        
        selectedItems.removeAll()
        substringArticles.removeAll()
        articleTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationButtonBackgroundView.layer.cornerRadius = 5
        
        //Segmented Control SetUp
        productTypeSegmentedControl.setTitle("Alle Produkte", forSegmentAt: 0)
        productTypeSegmentedControl.setTitle("Angebote", forSegmentAt: 1)
        

        //Tastatur soll verschwinden, wenn irgendwo getippt wird
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        
        articleTableView.dataSource = self
        articleTableView.delegate = self
        articleTableView.tableFooterView = UIView()
        
        //Registrieren NIB file (XIB file)
        articleTableView.register(UINib(nibName: "AutomaticSearchTableTableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        // Live auf Änderungen im TextField reagiern
        searchTextField.addTarget(self, action: #selector(NavigationViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
        articleTableView.reloadData()
    }
    
    
    
    //Diese Methode wird aufgerufen, wenn der Nutzer eine Änderung im TextField vorgenommen hat. (Ein weiterer Buchstaben getippt z.B.)
    @objc func textFieldDidChange(){
        
        //Sucht in der Datenbank nach Artikeln mit den eingegeben Buchstaben
        substringArticles = checkSubstringInArticle(substring: searchTextField.text!)
        
        //Erhält eine Liste zurück und lädt die Tabelle neu
        articleTableView.reloadData()
    }
    
    
    //Vorbereitung Übergang zum Route VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToRouteVC" {
            
            let destVC = segue.destination as! RoutingViewController
            destVC.nodesInRoute = selectedItems
            destVC.pixelCordinatesOfNodesInRoute = navigation.market.pixelsOfAllNodes
        }
        
        else if segue.identifier == "goToCartVC" {
            
            let destVC = segue.destination as! CartTableViewController
            
            destVC.itemArray = selectedArticles
            
            print("Die Artikel sind: \(selectedArticles)")
        }
    }
    
    
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {

        if selectedItems.isEmpty{
            let alertController = UIAlertController(title: "Ihre Einkaufsliste ist leer!", message:
                "Für die Routenberechnung muss sich mindestens 1 Artikel im Warenkorb befinden.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertController, animated: true, completion: nil)
            
        }else{
            performSegue(withIdentifier: "goToRouteVC", sender: self)
        }
    }
    
    //Diese Methode schaut in der Artikel-Datenbank, ob ein Item die Buchstabenfolge im Namen enthält und gibt eine Liste zurück mit den Artikel, die diese Buchstabenfolge im Namen haben
    func checkSubstringInArticle(substring: String) -> [Article] {
        var articleArray = [Article]()
        
        //Es soll erst nach 3 Buchstaben geschaut werden, sonst zeigt er ja alles an.
        if substring.count >= 3 {
            
            for article in articleDataBase.items {
                
                if article.getName().lowercased().contains(substring.lowercased()){
                    articleArray.append(article)
                }
            }
        }
        return articleArray
    }
}



//Delegate-Methoden um die Tabelle zu generieren
extension NavigationViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
       
        if substringArticles.count % 2 == 0 {
            return substringArticles.count/2
        }else{
            return substringArticles.count/2 + 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = articleTableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! SearchTableViewCell
        cell.delegate = self
        
        if indexPath.row < tableView.numberOfRows(inSection: 0) - 1 {
            

            let leftArticle = substringArticles[indexPath.row * 2]
            let rightArticle = substringArticles[indexPath.row * 2 + 1]
            
            cell.leftCellImage.image = leftArticle.getImage()
            cell.leftProductLabel.text = leftArticle.getName()
            cell.leftProductPrice.text = leftArticle.getPrice()
            cell.leftCardProductNode = leftArticle.getNode()
            cell.onlyOneProductCard = false

            cell.rightCellImage.image = rightArticle.getImage()
            cell.rightProductLabel.text = rightArticle.getName()
            cell.rightProductPrice.text = rightArticle.getPrice()
            cell.rightCardProductNode = rightArticle.getNode()
            cell.onlyOneProductCard = false
        }else{
            if let leftArticle = substringArticles.last {
                cell.leftCellImage.image = leftArticle.getImage()
                cell.leftProductLabel.text = leftArticle.getName()
                cell.leftProductPrice.text = leftArticle.getPrice()
                cell.leftCardProductNode = leftArticle.getNode()

                cell.onlyOneProductCard = true
                
            }
        }
            cell.selectionStyle = .default
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 290
    }
    
}

//Delegate-Methoden um mit der Tabelle zu interagoeren (auf Berührung reagieren)
extension NavigationViewController: UIScrollViewDelegate {
    
    //Wenn in der Tabelle gescrollt wird, soll die Tastatur verschwinden
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
}


