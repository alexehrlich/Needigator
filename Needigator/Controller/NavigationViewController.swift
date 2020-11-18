//
//  NavigationViewController.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 16.03.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit


class NavigationViewController: UIViewController, UITableViewDelegate{

    //Verbindung zum Interface-Builder
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var articleTableView: UITableView!
    @IBOutlet weak var productTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var searchFieldBackgroundView: UIView!
   
    let userFeedBackVC = UserFeedBackWhileCalculationViewController(nibName: "UserFeedBackWhileCalculationViewController", bundle: nil)
    
    //"Datenbank" der hard-coded Artikel
    let articleDataBase = ArticleDataBase()
    
    //Liste die mit den Artikeln gefüllt wird, die 3 im Textfeld eingegebenen Buchstaben enthalten
    var substringArticles = [Article]()
    
    
    //Zuständig für die Routenberechnung
    var navigation = RouteCalculationManager()
    

    //Globale Variablen um Card-View zu realisieren
    enum CardState {
        case expanded
        case collapsed
    }
    
    var cardViewController = CardViewController(nibName:"CardViewController", bundle:nil)
    var visualEffectView:UIVisualEffectView!
    
    let cardHeight:CGFloat = 600
    let cardHandleAreaHeight:CGFloat = 80
    
    
    var cardVisible = false
    var nextState:CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0
    
    
    //Wenn der Bildschirm auftaucht wenn man wieder zu diesem zurückkehrt, dann soll alles gelöscht sein.
    override func viewWillAppear(_ animated: Bool){
        
        userFeedBackVC.view.removeFromSuperview()
        
        //Für Card View
        cardVisible = true
        animateTransitionIfNeeded(state: nextState, duration: 0.1)
        
        Shopping.selectedProductsOfUser.removeAll()
        substringArticles = articleDataBase.items
        articleTableView.reloadData()
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(flipProductcardsIfNeeded), name: Messages.notificationNameForTappedProductCard, object: nil)
        
        //Tastatur soll verschwinden, wenn irgendwo getippt wird
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        
        //Card-View für Einkaufsliste
        setupCard()
        cardViewController.view.layer.shadowColor = UIColor.black.cgColor
        
        //Search-Textfield Layouting
        searchTextField.layer.cornerRadius = searchTextField.frame.size.height / 2
        searchFieldBackgroundView.layer.cornerRadius = searchFieldBackgroundView.frame.size.height / 2
        searchFieldBackgroundView.layer.shadowColor = UIColor.lightGray.cgColor
        searchFieldBackgroundView.layer.shadowOpacity = 0.2
        searchFieldBackgroundView.layer.shadowOffset = .zero
        searchFieldBackgroundView.layer.shadowRadius = searchFieldBackgroundView.frame.size.height / 2
        
        
        //Segmented Control SetUp
        productTypeSegmentedControl.setTitle("Alle Produkte", forSegmentAt: 0)
        productTypeSegmentedControl.setTitle("Angebote", forSegmentAt: 1)
        

        //Tastatur soll verschwinden, wenn irgendwo getippt wird
        _ = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        
        articleTableView.dataSource = self
        articleTableView.delegate = self
        articleTableView.tableFooterView = UIView() //Tabelle zeigt nur so viel Zeilen wie Elemente
        
        //Registrieren NIB file (XIB file)
        articleTableView.register(UINib(nibName: "SearchTableViewCellDesign", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        // Live auf Änderungen im TextField reagiern
        searchTextField.addTarget(self, action: #selector(NavigationViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
        articleTableView.reloadData()
    }
    
    
    
    
    //Diese Methode wird aufgerufen, wenn der Nutzer eine Änderung im TextField vorgenommen hat. (Ein weiterer Buchstaben getippt z.B.)
    @objc func textFieldDidChange(){
        
        if searchTextField.text == ""{
            substringArticles = articleDataBase.items
        }else{
            //Sucht in der Datenbank nach Artikeln mit den eingegeben Buchstaben
            substringArticles = checkSubstringInArticle(substring: searchTextField.text!)
        }
        
        print(substringArticles.count)
        //Erhält eine Liste zurück und lädt die Tabelle neu
        articleTableView.reloadData()
    }

    @IBAction func searchButtonPressed(_ sender: UIButton) {
        if Shopping.selectedProductsOfUser.isEmpty{
            let alertController = UIAlertController(title: "Ihre Einkaufsliste ist leer!", message:
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
    
    @objc func flipProductcardsIfNeeded(){
        
        for cell in articleTableView.visibleCells {
            
            let searchTableViewCell = cell as! SearchTableViewCell
            
            if searchTableViewCell.rightCardIsFlipped{
                
                searchTableViewCell.rightCardIsFlipped = false
                
                searchTableViewCell.rightDetailedProdSelectVC.removeFromParent()
                searchTableViewCell.rightDetailedProdSelectVC.view.removeFromSuperview()
                UIView.transition(with: searchTableViewCell.rightProductCardView, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
            }
            
            if searchTableViewCell.leftCardIsFlipped {
                
                searchTableViewCell.leftCardIsFlipped = false
                
                searchTableViewCell.leftDetailedProdSelectVC.removeFromParent()
                searchTableViewCell.leftDetailedProdSelectVC.view.removeFromSuperview()
                UIView.transition(with: searchTableViewCell.leftProductCardView, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
            }

        }
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
        if indexPath.row < tableView.numberOfRows(inSection: 0) - 1 || tableView.numberOfRows(inSection: 0) == 1 && substringArticles.count > 1{
            
            let leftArticle = substringArticles[indexPath.row * 2]
            let rightArticle = substringArticles[indexPath.row * 2 + 1]
            
            cell.leftCellImage.image = leftArticle.getImage()
            cell.leftProductLabel.text = leftArticle.getName()
            cell.leftProductPrice.text = leftArticle.getPrice()
            cell.leftCardProductNode = leftArticle.getNode()
            cell.leftCardArticle = leftArticle
            cell.onlyOneProductCard = false
            cell.leftCardIsFlipped = false

            cell.rightCellImage.image = rightArticle.getImage()
            cell.rightProductLabel.text = rightArticle.getName()
            cell.rightProductPrice.text = rightArticle.getPrice()
            cell.rightCardProductNode = rightArticle.getNode()
            cell.rightCardArticle = rightArticle
            cell.onlyOneProductCard = false
            cell.rightCardIsFlipped = false
            
        }else{
            if let leftArticle = substringArticles.last {
                cell.leftCellImage.image = leftArticle.getImage()
                cell.leftProductLabel.text = leftArticle.getName()
                cell.leftProductPrice.text = leftArticle.getPrice()
                cell.leftCardProductNode = leftArticle.getNode()
                cell.leftCardArticle = leftArticle
                cell.onlyOneProductCard = true
                cell.leftCardIsFlipped = false
                
            }
        }
        self.addChild(cell.leftDetailedProdSelectVC)
        self.addChild(cell.rightDetailedProdSelectVC)
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
        NotificationCenter.default.post(name: Messages.notificationNameForSearchTableVC, object: nil)
        self.view.endEditing(true)
    }
}

extension NavigationViewController: SearchTableViewCellDelegate{
    
    func getLeftProductCardArticle(article: Article, amount: Int) {
        updateSelectedItemsInModel(for: article, with: amount)
    }
    
    func getRightProductCardArticle(article: Article, amount: Int) {
        updateSelectedItemsInModel(for: article, with: amount)
    }
    
    func updateSelectedItemsInModel(for article: Article, with amount: Int){
        if Shopping.selectedProductsOfUser.contains(where: { (arg0) -> Bool in
            let (thisArticle, _) = arg0
            if thisArticle == article {
                return true
            }else{
                return false
            }
        }){
            var index = 0
            for item in Shopping.selectedProductsOfUser {
                if item.0 == article{
                    Shopping.selectedProductsOfUser[index].1 = amount
                }
                index = index + 1
            }
        }else{
            Shopping.selectedProductsOfUser.append((article, amount))
        }
    }
}

//Erweiterung um den CardView zu implementieren
extension NavigationViewController {

func setupCard() {
    
        self.addChild(cardViewController)
        self.view.addSubview(cardViewController.view)
        
        cardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight, width: self.view.bounds.width, height: cardHeight)
        cardViewController.view.layer.cornerRadius = 12
        
        
        cardViewController.view.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NavigationViewController.handleCardTap(recognzier:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(NavigationViewController.handleCardPan(recognizer:)))
        
        cardViewController.handleArea.addGestureRecognizer(tapGestureRecognizer)
        cardViewController.handleArea.addGestureRecognizer(panGestureRecognizer)
        
        
    }
    
    @objc func handleCardTap(recognzier:UITapGestureRecognizer) {

        cardViewController.selctedProductsTableView.reloadData()
        
            switch recognzier.state {
            case .ended:
                animateTransitionIfNeeded(state: nextState, duration: 0.9)
                
                if cardVisible == true {
                    self.view.endEditing(true)
                }
            default:
                break
            }
    }
    
    @objc
    func handleCardPan (recognizer:UIPanGestureRecognizer) {
        
        cardViewController.selctedProductsTableView.reloadData()
        
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.9)
        case .changed:
            let translation = recognizer.translation(in: self.cardViewController.headBar)
            var fractionComplete = translation.y / cardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            
            if fractionComplete > 0 {
                self.view.endEditing(true)
            }
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
        
    }
    
    func animateTransitionIfNeeded (state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.cardViewController.dragBarLabel.text = "Zum Schließen tippen oder nach unten ziehen."
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight
                case .collapsed:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight
                    self.cardViewController.dragBarLabel.text = "Für die Einfkaufsliate tippen oder nach oben ziehen."
                }
            }
            
            frameAnimator.addCompletion { _ in
                
                self.cardVisible = !self.cardVisible
                
                self.runningAnimations.removeAll()
            }
            
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
        }
    }
    
    func startInteractiveTransition(state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            
            //Damit wird die Animation angehalten und interactiv.
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    func updateInteractiveTransition(fractionCompleted:CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    func continueInteractiveTransition (){
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
}


