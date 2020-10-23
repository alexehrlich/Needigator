//
//  RoutingViewController.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 24.03.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit

class RoutingViewController: UIViewController, RouteCalculationManagerDelegate {
    func didFinishOptimizingRoute(result: Route) {
        routeImageView.image = drawRouteIntoMarketPlan(route: result)
    }
    
    
    //Umzug der Bild-Logik in diesen VC
    var pixelsOfAllNodes = [Int: CGPoint]()
    var drawCoordinateDictionary = [CGPoint]()
    
    
    @IBOutlet weak var routeImageView: UIImageView!
    @IBOutlet weak var navigationArrowImage: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    var navigation = RouteCalculationManager()
    var nodesInRoute = [Int]()
    var pixelCoordinatesInRoute = [CGPoint]()
    var pixelCordinatesOfNodesInRoute = [Int:CGPoint]()
    
    let articleDataBase = ArticleDataBase()
    
    
    var recursiveCounter = 0
    var secondRecursiveCounter = 0
    
    
    var seconNAvigationArrowImage = UIImage()
    var secondNavigationArrowImageView = UIImageView()
    
    var firstHalfDone = false
    
    
    //InformationView Stuff
    @IBOutlet weak var informationView: UIView!
    @IBOutlet weak var articleNameInView: UILabel!
    @IBOutlet weak var articlePriceInView: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.light))
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadNodes()
        loadRoutes()
        
        informationView.alpha = 0
        
        pixelCoordinatesInRoute = drawCoordinateDictionary
        
        for node in nodesInRoute{
            let startingPoint = CGPoint(x: routeImageView.center.x - routeImageView.frame.size.width/2, y: routeImageView.center.y - routeImageView.frame.size.height/2)
            let newProductPinButton = UIButton()
            newProductPinButton.frame = CGRect(origin: CGPoint(x: startingPoint.x + pixelsOfAllNodes[node]!.x/3, y: startingPoint.y + pixelsOfAllNodes[node]!.y/3), size: CGSize(width: 20, height: 20))
            newProductPinButton.center = CGPoint(x: startingPoint.x + pixelsOfAllNodes[node]!.x/3, y: startingPoint.y + pixelsOfAllNodes[node]!.y/3 - newProductPinButton.frame.size.height/2)
            newProductPinButton.setImage(UIImage(named: "product_map"), for: .normal)
            newProductPinButton.imageView?.tintColor = .white
            newProductPinButton.addTarget(self, action: #selector(productMapButtonPressed), for: .touchUpInside)
            newProductPinButton.alpha = 1
            newProductPinButton.isHidden = false
            newProductPinButton.tag = node
            self.view.addSubview(newProductPinButton)
        }
        
        informationView.layer.cornerRadius = 10
        navigation.delegate = self
        navigation.prepareRoute(nodes: nodesInRoute)
        navigationArrowImage.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        //navigationArrowImage.alpha = 0
        
        seconNAvigationArrowImage = UIImage(systemName: "cart")!
        secondNavigationArrowImageView = UIImageView(image: seconNAvigationArrowImage)
        secondNavigationArrowImageView.tintColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        secondNavigationArrowImageView.contentMode = .scaleAspectFit
        secondNavigationArrowImageView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 20, height: 20))
        secondNavigationArrowImageView.isHidden = true
        self.view.addSubview(secondNavigationArrowImageView)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationArrowImage.isHidden = false
        
            moveFirstNavigationArrow()
        
    }
    
//    func moveFirstNavigationArrow(){
//        let startingPoint = CGPoint(x: routeImageView.center.x - routeImageView.frame.size.width/2, y: routeImageView.center.y - routeImageView.frame.size.height/2)
//
//        for index in 0..<drawCoordinateDictionary.count {
//
//                        let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (timer) in
//                            self.navigationArrowImage.center = CGPoint(x: startingPoint.x + self.drawCoordinateDictionary[index].x/3, y: startingPoint.y + self.drawCoordinateDictionary[index].y/3)
//                        }
//        }
//    }
    
    
        func moveFirstNavigationArrow(){
    
            if Double(recursiveCounter)/Double(pixelCoordinatesInRoute.count) > 0.5 {
                firstHalfDone = true
            }
    
            if recursiveCounter == 0 {
                UIView.animate(withDuration: 0.8) {
                    self.navigationArrowImage.alpha = 1.0
                }
    
            }
    
            if recursiveCounter > pixelCoordinatesInRoute.count - 40 {
                navigationArrowImage.alpha *= 0.9
            }
    
            let startingPoint = CGPoint(x: routeImageView.center.x - routeImageView.frame.size.width/2, y: routeImageView.center.y - routeImageView.frame.size.height/2)
    
            if recursiveCounter < pixelCoordinatesInRoute.count {
    
                navigationArrowImage.center = CGPoint(x: startingPoint.x + pixelCoordinatesInRoute[recursiveCounter].x/3, y: startingPoint.y + pixelCoordinatesInRoute[recursiveCounter].y/3)
    
    
    
                let _ = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: false) { (timer) in
    
                    self.recursiveCounter += 1
                    self.moveFirstNavigationArrow()
    
                    if self.firstHalfDone == true {
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
                    self.secondNavigationArrowImageView.alpha = 1
                }
            }
    
            if secondRecursiveCounter > pixelCoordinatesInRoute.count - 40 {
                secondNavigationArrowImageView.alpha *= 0.9
            }
    
            let startingPoint = CGPoint(x: routeImageView.center.x - routeImageView.frame.size.width/2, y: routeImageView.center.y - routeImageView.frame.size.height/2)
    
            if secondRecursiveCounter < pixelCoordinatesInRoute.count {
    
                secondNavigationArrowImageView.center = CGPoint(x: startingPoint.x + pixelCoordinatesInRoute[secondRecursiveCounter].x/3, y: startingPoint.y + pixelCoordinatesInRoute[secondRecursiveCounter].y/3)
                secondNavigationArrowImageView.isHidden = false
                let _ = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: false) { (timer) in
    
    
                    self.secondRecursiveCounter += 1
    
                }
            }else{
                secondRecursiveCounter = 0
                moveSecondNavigationArrow()
            }
        }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        
        if touch?.view != informationView {
            UIView.animate(withDuration: 0.5) {
                self.informationView.alpha = 0
                self.blurEffectView.removeFromSuperview()
            }
        }
        
    }
    
    @objc func productMapButtonPressed(button: UIButton){
        
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
        //INFO: positionierung funktioniet noch nicht!
        informationView.frame.origin = CGPoint(x: button.center.x , y: button.center.y + button.frame.size.height/2)
        
        for article in articleDataBase.items {
            
            if button.tag == article.getNode() {
                
                articleImageView.image = article.getImage()
                articleNameInView.text = article.getName()
                articlePriceInView.text = article.getPrice()
            }
        }
        
        informationView.backgroundColor = .white
        self.view.addSubview(informationView)
        informationView.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.informationView.alpha = 1
        }
    }
}

//hier kommt alles rein, was wwir testweise velagern wollen
extension RoutingViewController {
    
    //Imgae-Handling --> sollte in eigene Klasse
    //Diese Funktion bereitet das Bild (Marktplan) zur Bearbeitung vor, lädt alle Knoten und findet für jeden Knoten die Nachbarknoten.
    func loadNodes(){
        
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
        
        for column in 0..<Int(width) {
            for row in 0..<Int(height) {
                if pixelBuffer[getCurrentPixelPosition(y: row, width: width, x: column)] == .red {
                    Market.allNodesInMarket.append(Node(name: nodesCounter, xPosition: column, yPosition: row))
                    pixelsOfAllNodes[nodesCounter] = CGPoint(x: column, y: row)
                    nodesCounter += 1
                }
            }
        }
        //Ende Bildvorbereitung --> bild kann jetzt analysiert werden
        
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
        print("Knoten wurden erfolgreich geladen")
    }
    
    
    //Imgae-Handling --> sollte in eigene Klasse
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
    
    //Imgae-Handling --> sollte in eigene Klasse
    func getDrawPixelCoordinates() -> [CGPoint]{
        return drawCoordinateDictionary
    }
    
    
    //Imgae-Handling --> sollte in eigene Klasse
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
                        
                        drawCoordinateDictionary.append(CGPoint(x: fixedXPosition, y: nextY))
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
                        drawCoordinateDictionary.append(CGPoint(x: fixedXPosition, y: nextY))
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
                        drawCoordinateDictionary.append(CGPoint(x: nextX, y: fixedYPosition))
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
                        drawCoordinateDictionary.append(CGPoint(x: nextX, y: fixedYPosition))
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
    
    func loadRoutes(){
        //READ Textfile
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


