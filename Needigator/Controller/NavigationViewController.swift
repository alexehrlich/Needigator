//
//  NavigationViewController.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 16.03.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit

class NavigationViewController: UIViewController, UITableViewDelegate, CalculationComplete{
    
    func didFinishWithCalculation() {
        print("Calculation Done!")
    }
    

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var articleTableView: UITableView!
    @IBOutlet weak var addedWindowBackgroundView: UIImageView!
    
    @IBOutlet weak var addedWindowView: UIView!
    @IBOutlet weak var calculatingView: UIView!
    @IBOutlet weak var gearImageView: UIImageView!
    
   
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
        
        amountItemsOutlet.text = String(amountOfItems)
        
        addedWindowView.alpha = 0
        calculatingView.alpha = 0
        
        selectedItems.removeAll()
        substringArticles.removeAll()
        articleTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articleTableView.rowHeight = 220
        
        navigation.calculationDelegate = self
        
        //Berechnungs Übergangsfenster
        calculatingView.alpha = 0
        
        //Einstellungen am Hinzugefügt Fensterchen
        addedWindowBackgroundView.layer.cornerRadius = 10
        
        
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

        //Button Form einstellung
        cartButtonOutlet.layer.cornerRadius = 5
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
        
        
        if selectedItems.isEmpty == false {
            
            UIView.animate(withDuration: 0.2) {
                self.calculatingView.alpha = 1.0
            }
            
            for i in 1...8 {
                
                UIView.animate(withDuration: 3.0, animations: {
                    self.gearImageView.transform = CGAffineTransform(rotationAngle: CGFloat(i) * (180.0 * .pi) / 180.0)
                })
            }
            
            //Warte bis die Animation ausgeführt ist und perform dann erst den Übergang
            DispatchQueue.main.asyncAfter(deadline:.now() + 0.1, execute: {
                self.performSegue(withIdentifier: "goToRouteVC", sender: self)
                self.searchTextField.text = ""
            })
            
            
        }else{
            let alertController = UIAlertController(title: "Ihr Warenkorb ist leer", message:
                "Für die Routenberechnung muss sich mindestens 1 Artikel im Warenkorb befinden!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alertController, animated: true, completion: nil)
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
        return substringArticles.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let article = substringArticles[indexPath.row]
        
        let cell = articleTableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! AutomaticSearchTableTableViewCell
        
        cell.delegate = self
        
//        cell.clearBackgroundView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        cell.backgroundImageView.backgroundColor = UIColor.white
        cell.backgroundImageView.alpha = 0.7
        cell.backgroundImageView.layer.cornerRadius = 10
        cell.selectionStyle = .default
        
        
        
        cell.articleImageView.image = article.getImage()
        
        if article.getInfo() != " " {
            cell.articleInfoOutlet.text = article.getInfo()
        }else {
            cell.articleInfoOutlet.text = "Keine Produktinformation"
        }
        cell.articleNameOutlet.text = article.getName()
        cell.articlePriceOutlet.text = article.getPrice()
        cell.articleNodeNumber = article.getNode()
        
        return cell
    }
    
}

//Diese Delegate-Methode ist notwenidig um die Informationen bei einem Button-Press innerhalb der Zelle zu bekommen
extension NavigationViewController: AutomaticSearchTableTableViewCellDelegate {
    func automaticSearchTableTableViewCell(_ automaticSearchTableTableViewCell: AutomaticSearchTableTableViewCell, articleName item: Int) {
        
        if !selectedItems.contains(item) {
            
            automaticSearchTableTableViewCell.amountOfItem += 1
            automaticSearchTableTableViewCell.amountItemLabel.text = String(amountOfItems)
            selectedItems.append(item)
            print("Items: \(selectedItems)")
            selectedArticles.append(automaticSearchTableTableViewCell.articleNameOutlet.text!)
        }
        
        
        UIView.animate(withDuration: 0.2) {
            self.addedWindowView.alpha = 1.0
        }
        UIView.animate(withDuration: 1) {
            self.addedWindowView.alpha = 0
        }
        
    }
    
    
}


//Delegate-Methoden um mit der Tabelle zu interagoeren (auf Berührung reagieren)
extension NavigationViewController: UIScrollViewDelegate {
    
    //Wenn in der Tabelle gescrollt wird, soll die Tastatur verschwinden
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
}


