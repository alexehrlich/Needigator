//
//  RoutingViewController.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 24.03.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit

class RoutingViewController: UIViewController, AddListToFavoritesViewControllerDelegate {
    
    //MARK: IB-Outlets:
    @IBOutlet weak var routeImageView: UIImageView!
    @IBOutlet weak var firstNavigationImage: UIImageView!
    @IBOutlet weak var colorLegendButtonView: UIView!
    @IBOutlet weak var addToFavsButtonView: UIView!
    @IBOutlet weak var finishShoppingButtonView: UIView!
    
    
    //InformationView Stuff
    @IBOutlet weak var productViewOfMapMarker: UIView!
    @IBOutlet weak var articleNameInView: UILabel!
    @IBOutlet weak var articlePriceInView: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    
    
    //MARK: Class-Instances:
    let articleDataBase = ArticleDataBase()
    var navigation = RouteCalculationManager()
    let listOfProductsToDisplay = ListOfProductsInOneNodeViewController()
    let addingViewController = AddListToFavoritesViewController()
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.light))
    
    //MARK: Global variables
    var pixelsOfAllNodes = [Int: CGPoint]()
    var nodesInRoute = [Int]()
    var pixelCoordinatesInRoute = [CGPoint]()
    
    
    //MARK: Global variables navigation image movement
    var recursiveCounter = 0
    var secondRecursiveCounter = 0
    var secondNavigationImage = UIImage()
    var secondNavigationImageView = UIImageView()
    var firstNavigationImageHasCoveredHalfRoute = false
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        Shopping.checkedProducts.removeAll()
        
        addingViewController.addingDelegate = self
        
        navigationController?.isNavigationBarHidden = false
        
        //Lade die Knoten vom MArktplan und die kürzesten Routen zwischen allen Knoten aus dem Textfile
        loadNodesFromMarketPlan()
        loadRoutesFromTextFile()
        
        //Setze den RoutingVC als Delegate der Berechung veranlasse die Berechnung der Route mit prepareRoute() -->Die Antwort der Berechnugn kommt in der Protokollmethode didFinishOptimizingRoute(result: Route)
        navigation.delegate = self
        navigation.prepareRoute()
        
        
        //Loop: Für jedes Produkt wird ein neuer Pin erstellt und an den Knoten platziert
        for (article, _) in Shopping.selectedProductsOfUser{
            
            let startingPoint = CGPoint(x: routeImageView.center.x - routeImageView.frame.size.width/2, y: routeImageView.center.y - routeImageView.frame.size.height/2)
            let newProductPinButton = UIButton()
            newProductPinButton.frame = CGRect(origin: CGPoint(x: startingPoint.x + pixelsOfAllNodes[article.getNode()]!.x/3, y: startingPoint.y + pixelsOfAllNodes[article.getNode()]!.y/3), size: CGSize(width: 20, height: 20))
            newProductPinButton.center = CGPoint(x: startingPoint.x + pixelsOfAllNodes[article.getNode()]!.x/3, y: startingPoint.y + pixelsOfAllNodes[article.getNode()]!.y/3 - newProductPinButton.frame.size.height/2)
            newProductPinButton.setImage(UIImage(named: "product_map"), for: .normal)
            newProductPinButton.imageView?.tintColor = .white
            newProductPinButton.addTarget(self, action: #selector(productMapButtonPressed), for: .touchUpInside)
            newProductPinButton.alpha = 1
            newProductPinButton.isHidden = false
            newProductPinButton.tag = article.getNode()
            self.view.addSubview(newProductPinButton)
        }
        
        
        
        //Layout of firstNavigationImage
        firstNavigationImage.tintColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        firstNavigationImage.alpha = 0
        
        //Layout Button Views
        colorLegendButtonView.layer.cornerRadius = colorLegendButtonView.frame.size.height/2
        colorLegendButtonView.layer.shadowColor = UIColor.lightGray.cgColor
        colorLegendButtonView.layer.shadowOpacity = 0.5
        colorLegendButtonView.layer.shadowOffset = .zero
        colorLegendButtonView.layer.shadowRadius = 10
        
        addToFavsButtonView.layer.cornerRadius = colorLegendButtonView.frame.size.height/2
        addToFavsButtonView.layer.shadowColor = UIColor.lightGray.cgColor
        addToFavsButtonView.layer.shadowOpacity = 0.5
        addToFavsButtonView.layer.shadowOffset = .zero
        addToFavsButtonView.layer.shadowRadius = 10
        
        finishShoppingButtonView.layer.cornerRadius = colorLegendButtonView.frame.size.height/2
        finishShoppingButtonView.layer.shadowColor = UIColor.lightGray.cgColor
        finishShoppingButtonView.layer.shadowOpacity = 0.5
        finishShoppingButtonView.layer.shadowOffset = .zero
        finishShoppingButtonView.layer.shadowRadius = 10
        
        
        
        
        //Set-up and layout of second Navigation Image
        secondNavigationImage = UIImage(systemName: "cart")!
        secondNavigationImageView = UIImageView(image: secondNavigationImage)
        secondNavigationImageView.tintColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        secondNavigationImageView.contentMode = .scaleAspectFit
        secondNavigationImageView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 20, height: 20))
        secondNavigationImageView.isHidden = true
        self.view.addSubview(secondNavigationImageView)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        firstNavigationImage.isHidden = false
        moveFirstNavigationArrow()
    }
    
    //Funktionen für die Buttons:
    
    @IBAction func addListToFavsButtonPressed(_ sender: UIButton) {
        
        addingViewController.view.frame = CGRect(x: 60, y: self.view.frame.height, width: self.view.frame.width * 0.7, height: self.view.frame.height * 0.4)
        addingViewController.view.layer.cornerRadius = 12
        
        self.view.addSubview(addingViewController.view)
        self.addChild(addingViewController)
        addingViewController.listNameEnterTextField.text = ""
        UIView.animate(withDuration: 0.8, animations: {
            self.addingViewController.view.frame.origin = CGPoint(x: 60, y: 300)
        })
        
    }
    
    func userDidFinishAdding() {
        self.view.endEditing(true)
    }
    
    @IBAction func finishShoppingButtonPressed(_ sender: UIButton) {
        Shopping.selectedProductsOfUser.removeAll()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func keyboardWillShowUp(notification : NSNotification){
        
        if let keyBoardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
            
            let keyBoardFrameHeight = keyBoardFrame.cgRectValue.height
            UIView.animate(withDuration: 0.8, animations: {
                self.addingViewController.view.frame.origin = CGPoint(x: 60, y: self.view.frame.height - keyBoardFrameHeight - self.addingViewController.view.frame.height - 15)
            })
        }
    }
    
    
    //Wenn neben die Karte gedrückt wird, soll diese wieder verschwinden
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        
        if touch?.view != listOfProductsToDisplay.view {
            UIView.animate(withDuration: 0.5) {
                self.listOfProductsToDisplay.removeFromParent()
                self.listOfProductsToDisplay.view.removeFromSuperview()
                self.blurEffectView.removeFromSuperview()
            }
        }
        
        self.view.endEditing(true)
    }
    
    //Zeigt die Produktinformationen in dem Extra-View an
    @objc func productMapButtonPressed(button: UIButton){
        
        
        listOfProductsToDisplay.nodeNumber = button.tag
        
        listOfProductsToDisplay.view.frame = CGRect(x: self.view.center.x, y: self.view.center.y, width: self.view.frame.width * 0.7, height: self.view.frame.height * 0.3)
        
        listOfProductsToDisplay.view.center = self.view.center
        
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        self.addChild(listOfProductsToDisplay)
        self.view.addSubview(listOfProductsToDisplay.view)
        
    }
}

//MARK: Markt-Daten laden und Route in das Bild zeichnen
extension RoutingViewController {
    
    //Diese Funktion bereitet das Bild (Marktplan) zur Bearbeitung vor, lädt alle Knoten und findet für jeden Knoten die Nachbarknoten.
    func loadNodesFromMarketPlan(){
        
        var nodesCounter = 0
        
        //Folgender Code lädt das Image und bereitet es zur bearbeitung vor
        guard let inputCGImage = Market.bitMapMarketPlan2D?.cgImage else {
            return
        }
        
        let colorSpace       = CGColorSpaceCreateDeviceRGB()
        let width            = inputCGImage.width
        let height           = inputCGImage.height
        let bytesPerPixel    = 4
        let bitsPerComponent = 8
        let bytesPerRow      = bytesPerPixel * width
        let bitmapInfo       = RGBA32.bitmapInfo
        
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            return
        }
        context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let buffer = context.data else {
            return
        }
        
        let pixelBuffer = buffer.bindMemory(to: RGBA32.self, capacity: width * height)
        //Ende Bildvorbereitung --> bild kann jetzt analysiert werden
        
        
        for column in 0..<Int(width) {
            for row in 0..<Int(height) {
                if pixelBuffer[getCurrentPixelPosition(y: row, width: width, x: column)] == .red {
                    Market.allNodesInMarket.append(Node(name: nodesCounter, xPosition: column, yPosition: row))
                    pixelsOfAllNodes[nodesCounter] = CGPoint(x: column, y: row)
                    nodesCounter += 1
                }
            }
        }
        
        //In dieser Schleife werden alle Knoten aus dem Bild(Marktplan) geladen
        for i in 0..<Market.allNodesInMarket.count {
            
            let pX = Market.allNodesInMarket[i].getXPosition()
            let pY = Market.allNodesInMarket[i].getYPosition()
            
            var nextX = pX
            var nextY = pY
            
            //Im folgenden Code werden für alle geladenen Knoten die Nachbarknoten geladen
            // In positiver x-Richtung nach Node suchen
            while (nextX + 1) < inputCGImage.width {
                
                nextX += 1
                
                if pixelBuffer[getCurrentPixelPosition(y: pY, width: width, x: nextX)] == RGBA32.red {
                    Market.allNodesInMarket[i].addConnectedNode(node: getNodesByCoordinate(x: nextX, y: pY))
                    break
                }else if pixelBuffer[getCurrentPixelPosition(y: pY, width: width, x: nextX)] == RGBA32.white {
                    break
                }
            }
            
            //In positiver y-Richtung nach Node suchen
            while nextY + 1 < inputCGImage.height {
                
                nextY += 1
                
                if pixelBuffer[getCurrentPixelPosition(y: nextY, width: width, x: pX)] == RGBA32.red {
                    Market.allNodesInMarket[i].addConnectedNode(node: getNodesByCoordinate(x: pX, y: nextY))
                    break
                }else if pixelBuffer[getCurrentPixelPosition(y: nextY, width: width, x: pX)] == RGBA32.white {
                    break
                }
            }
            
            //Punkt für Suche wieder an Ursprungspunkt zurücksetzen
            nextX = pX
            nextY = pY
            
            //In negativer x-Richtung nach Node suchen
            while nextX - 1 < inputCGImage.width && nextX - 1 > 0{
                
                nextX -= 1
                
                if pixelBuffer[getCurrentPixelPosition(y: pY, width: width, x: nextX)] == RGBA32.red {
                    Market.allNodesInMarket[i].addConnectedNode(node: getNodesByCoordinate(x: nextX, y: pY))
                    break
                }else if pixelBuffer[getCurrentPixelPosition(y: pY, width: width, x: nextX)] == RGBA32.white {
                    break
                }
            }
            
            
            // In negativer y-Richutng nach Node suchen
            while nextY - 1 < inputCGImage.height && nextY - 1 > 0{
                
                nextY -= 1
                
                if pixelBuffer[getCurrentPixelPosition(y: nextY, width: width, x: pX)] == RGBA32.red {
                    Market.allNodesInMarket[i].addConnectedNode(node: getNodesByCoordinate(x: pX, y: nextY))
                    break
                }else if pixelBuffer[getCurrentPixelPosition(y: nextY, width: width, x: pX)] == RGBA32.white {
                    break
                }
            }
        }
    }
    
    
    func getCurrentPixelPosition(y row: Int, width: Int, x column: Int) -> Int {
        return row * width + column
    }
    
    func getNodesByCoordinate(x: Int, y: Int) -> Int {
        
        for i in 0..<Market.allNodesInMarket.count {
            if Market.allNodesInMarket[i].getXPosition() == x && Market.allNodesInMarket[i].getYPosition() == y {
                return i
            }
        }
        return 0
    }
    
    
    func drawRouteIntoMarketPlan(route: Route) -> UIImage?{
        
        guard let inputCGImage = Market.bitMapMarketPlan2D?.cgImage else {
            print("unable to get cgImage")
            return nil
        }
        
        let colorSpace       = CGColorSpaceCreateDeviceRGB()
        let width            = inputCGImage.width
        let height           = inputCGImage.height
        let bytesPerPixel    = 4
        let bitsPerComponent = 8
        let bytesPerRow      = bytesPerPixel * width
        let bitmapInfo       = RGBA32.bitmapInfo
        
        
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            print("unable to create context")
            return nil
        }
        context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let buffer = context.data else {
            print("unable to get context data")
            return nil
        }
        
        let pixelBuffer = buffer.bindMemory(to: RGBA32.self, capacity: width * height)
        
        
        for i in 0..<route.getListOfNodesInRoute().count - 1{
            
            let currentNode = route.getListOfNodesInRoute()[i]
            
            //Wenn der aktuelle Knoten und der Folgeknoten die gleiche x-Position haben, soll nur in y-Richtung gelaufen und gemalt werden.
            
            if route.getListOfNodesInRoute()[i].getXPosition() == route.getListOfNodesInRoute()[i + 1].getXPosition(){
                
                let fixedXPosition = currentNode.getXPosition()
                
                //Wenn der y-Wert des Folgeknoten höher ist, dann soll in positive y-Richtung gelaufen werden
                //Wenn der y-Wert des Folgeknoten kleiner ist, dann soll in negative y-Richtung gelaufen werden
                
                if route.getListOfNodesInRoute()[i].getYPosition() < route.getListOfNodesInRoute()[i + 1].getYPosition() {
                    
                    var nextY = currentNode.getYPosition() + 1
                    
                    pixelBuffer[getCurrentPixelPosition(y: currentNode.getYPosition(), width: width, x: fixedXPosition)] = .red
                    pixelBuffer[getCurrentPixelPosition(y: currentNode.getYPosition(), width: width, x: fixedXPosition + 1)] = .red
                    pixelBuffer[getCurrentPixelPosition(y: currentNode.getYPosition(), width: width, x: fixedXPosition + 2)] = .red
                    pixelBuffer[getCurrentPixelPosition(y: currentNode.getYPosition(), width: width, x: fixedXPosition - 1)] = .red
                    pixelBuffer[getCurrentPixelPosition(y: currentNode.getYPosition(), width: width, x: fixedXPosition - 2)] = .red
                    
                    while nextY != route.getListOfNodesInRoute()[i + 1].getYPosition() {
                        
                        pixelCoordinatesInRoute.append(CGPoint(x: fixedXPosition, y: nextY))
                        pixelBuffer[getCurrentPixelPosition(y: nextY, width: width, x: fixedXPosition)] = .red
                        pixelBuffer[getCurrentPixelPosition(y: nextY, width: width, x: fixedXPosition + 1)] = .red
                        pixelBuffer[getCurrentPixelPosition(y: nextY, width: width, x: fixedXPosition + 2)] = .red
                        pixelBuffer[getCurrentPixelPosition(y: nextY, width: width, x: fixedXPosition - 1)] = .red
                        pixelBuffer[getCurrentPixelPosition(y: nextY, width: width, x: fixedXPosition - 2)] = .red
                        
                        nextY += 1
                        
                    }
                } else {
                    var nextY = currentNode.getYPosition()  - 1
                    
                    pixelBuffer[getCurrentPixelPosition(y: currentNode.getYPosition(), width: width, x: fixedXPosition)] = .red
                    pixelBuffer[getCurrentPixelPosition(y: currentNode.getYPosition(), width: width, x: fixedXPosition + 1)] = .red
                    pixelBuffer[getCurrentPixelPosition(y: currentNode.getYPosition(), width: width, x: fixedXPosition + 2)] = .red
                    pixelBuffer[getCurrentPixelPosition(y: currentNode.getYPosition(), width: width, x: fixedXPosition - 1)] = .red
                    pixelBuffer[getCurrentPixelPosition(y: currentNode.getYPosition(), width: width, x: fixedXPosition - 2)] = .red
                    
                    while nextY != route.getListOfNodesInRoute()[i + 1].getYPosition() {
                        pixelCoordinatesInRoute.append(CGPoint(x: fixedXPosition, y: nextY))
                        pixelBuffer[getCurrentPixelPosition(y: nextY, width: width, x: fixedXPosition)] = .red
                        pixelBuffer[getCurrentPixelPosition(y: nextY, width: width, x: fixedXPosition + 1)] = .red
                        pixelBuffer[getCurrentPixelPosition(y: nextY, width: width, x: fixedXPosition + 2)] = .red
                        pixelBuffer[getCurrentPixelPosition(y: nextY, width: width, x: fixedXPosition - 1)] = .red
                        pixelBuffer[getCurrentPixelPosition(y: nextY, width: width, x: fixedXPosition - 2)] = .red
                        nextY -=  1
                    }
                }
            } else  if route.getListOfNodesInRoute()[i].getYPosition() == route.getListOfNodesInRoute()[i + 1].getYPosition(){
                let fixedYPosition = currentNode.getYPosition()
                
                if route.getListOfNodesInRoute()[i].getXPosition() < route.getListOfNodesInRoute()[i + 1].getXPosition(){
                    var nextX = currentNode.getXPosition() + 1
                    
                    pixelBuffer[getCurrentPixelPosition(y: fixedYPosition, width: width, x: currentNode.getXPosition())] = .red
                    pixelBuffer[getCurrentPixelPosition(y: fixedYPosition, width: width, x: currentNode.getXPosition() + 1)] = .red
                    pixelBuffer[getCurrentPixelPosition(y: fixedYPosition, width: width, x: currentNode.getXPosition() + 2)] = .red
                    pixelBuffer[getCurrentPixelPosition(y: fixedYPosition, width: width, x: currentNode.getXPosition() - 1)] = .red
                    pixelBuffer[getCurrentPixelPosition(y: fixedYPosition, width: width, x: currentNode.getXPosition() - 2)] = .red
                    
                    while nextX != route.getListOfNodesInRoute()[i + 1].getXPosition() {
                        pixelCoordinatesInRoute.append(CGPoint(x: nextX, y: fixedYPosition))
                        pixelBuffer[getCurrentPixelPosition(y: fixedYPosition, width: width, x: nextX)] = .red
                        pixelBuffer[getCurrentPixelPosition(y: fixedYPosition + 1, width: width, x: nextX)] = .red
                        pixelBuffer[getCurrentPixelPosition(y: fixedYPosition + 2, width: width, x: nextX)] = .red
                        pixelBuffer[getCurrentPixelPosition(y: fixedYPosition - 1, width: width, x: nextX)] = .red
                        pixelBuffer[getCurrentPixelPosition(y: fixedYPosition - 2 , width: width, x: nextX)] = .red
                        nextX += 1
                    }
                } else {
                    var nextX = currentNode.getXPosition()  - 1
                    
                    pixelBuffer[getCurrentPixelPosition(y: fixedYPosition, width: width, x: currentNode.getXPosition())] = .red
                    pixelBuffer[getCurrentPixelPosition(y: fixedYPosition, width: width, x: currentNode.getXPosition() + 1)] = .red
                    pixelBuffer[getCurrentPixelPosition(y: fixedYPosition, width: width, x: currentNode.getXPosition() + 2)] = .red
                    pixelBuffer[getCurrentPixelPosition(y: fixedYPosition, width: width, x: currentNode.getXPosition() - 1)] = .red
                    pixelBuffer[getCurrentPixelPosition(y: fixedYPosition, width: width, x: currentNode.getXPosition() - 2)] = .red
                    
                    while nextX != route.getListOfNodesInRoute()[i + 1].getXPosition() {
                        pixelCoordinatesInRoute.append(CGPoint(x: nextX, y: fixedYPosition))
                        pixelBuffer[getCurrentPixelPosition(y: fixedYPosition, width: width, x: nextX)] = .red
                        pixelBuffer[getCurrentPixelPosition(y: fixedYPosition + 1, width: width, x: nextX)] = .red
                        pixelBuffer[getCurrentPixelPosition(y: fixedYPosition + 2, width: width, x: nextX)] = .red
                        pixelBuffer[getCurrentPixelPosition(y: fixedYPosition - 1, width: width, x: nextX)] = .red
                        pixelBuffer[getCurrentPixelPosition(y: fixedYPosition - 2 , width: width, x: nextX)] = .red
                        nextX -=  1
                    }
                }
            }
            
        }
        let outputCGImage = context.makeImage()!
        let outputImage = UIImage(cgImage: outputCGImage, scale: Market.bitMapMarketPlan2D!.scale, orientation: Market.bitMapMarketPlan2D!.imageOrientation)
        
        return outputImage
    }
    
    func loadRoutesFromTextFile(){
        
        if let path = Bundle.main.path(forResource: "AllRoutes", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let lines: [String] = data.components(separatedBy: .newlines)
                var tempNodeArray = [Node]()
                
                for line in lines{
                    for nodeNumber in line.split(separator: ","){
                        tempNodeArray.append(Market.allNodesInMarket[Int(nodeNumber)!])
                    }
                    
                    Market.finalRoutes.append(Route(nodes: tempNodeArray))
                    tempNodeArray = [Node]()
                }
                
                print("Routen erfolgreich geladen")
            } catch {
                print("Fehler beim Laden der Datei.")
                print(error.localizedDescription)
            }
        }
    }
}

//MARK: Message-Delegate from RouteCalculationManager
extension RoutingViewController: RouteCalculationManagerDelegate{
    func didFinishOptimizingRoute(result: Route) {
        routeImageView.image = drawRouteIntoMarketPlan(route: result)
    }
}


//MARK: Bewegen der Navigationbilder, welche die Route abfahren.
extension RoutingViewController {
    func moveFirstNavigationArrow(){
        
        if Double(recursiveCounter)/Double(pixelCoordinatesInRoute.count) > 0.5 {
            firstNavigationImageHasCoveredHalfRoute = true
        }
        
        if recursiveCounter == 0 {
            UIView.animate(withDuration: 0.8) {
                self.firstNavigationImage.alpha = 1.0
            }
            
        }
        
        if recursiveCounter > pixelCoordinatesInRoute.count - 40 {
            firstNavigationImage.alpha *= 0.9
        }
        
        let startingPoint = CGPoint(x: routeImageView.center.x - routeImageView.frame.size.width/2, y: routeImageView.center.y - routeImageView.frame.size.height/2)
        
        if recursiveCounter < pixelCoordinatesInRoute.count {
            
            firstNavigationImage.center = CGPoint(x: startingPoint.x + pixelCoordinatesInRoute[recursiveCounter].x/3, y: startingPoint.y + pixelCoordinatesInRoute[recursiveCounter].y/3)
            
            let _ = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: false) { (timer) in
                
                self.recursiveCounter += 1
                self.moveFirstNavigationArrow()
                
                if self.firstNavigationImageHasCoveredHalfRoute == true {
                    self.moveSecondNavigationArrow()
                }
            }
        }else{
            recursiveCounter = 0
            moveFirstNavigationArrow()
        }
    }
    
    
    func moveSecondNavigationArrow(){
        
        if self.secondRecursiveCounter == 0{
            UIView.animate(withDuration: 0.8) {
                self.secondNavigationImageView.alpha = 1
            }
        }
        
        if secondRecursiveCounter > pixelCoordinatesInRoute.count - 40 {
            secondNavigationImageView.alpha *= 0.9
        }
        
        let startingPoint = CGPoint(x: routeImageView.center.x - routeImageView.frame.size.width/2, y: routeImageView.center.y - routeImageView.frame.size.height/2)
        
        if secondRecursiveCounter < pixelCoordinatesInRoute.count {
            
            secondNavigationImageView.center = CGPoint(x: startingPoint.x + pixelCoordinatesInRoute[secondRecursiveCounter].x/3, y: startingPoint.y + pixelCoordinatesInRoute[secondRecursiveCounter].y/3)
            secondNavigationImageView.isHidden = false
            let _ = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: false) { (timer) in
                self.secondRecursiveCounter += 1
            }
        }else{
            secondRecursiveCounter = 0
            moveSecondNavigationArrow()
        }
    }
}



