//
//  Market.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 31.03.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit

struct Market {
    
    var end = 0
    var bitMapMarketPlan2D = UIImage(named: "NODES_1242x1065_colored")
    var allNodesInMarket = [Node]()
    var pathsToRoutesFile: String = "AllRoutes.txt"
    var finalRoutes = [Route]()
    private var routesToItem: [Route] = [Route]()
    private var nodesInRoute: [Node] = [Node]()
    var pixelsOfAllNodes = [Int: CGPoint]()
    
    var drawCoordinateDictionary = [CGPoint]()
    
    
    init() {
        loadNodes()
        loadRoutes()
    }
    
    mutating func loadNodes(){
        
        var nodesCounter = 0
        
        guard let inputCGImage = bitMapMarketPlan2D?.cgImage else {
            print("unable to get cgImage")
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
            //print("unable to create context")
            return
        }
        context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let buffer = context.data else {
            //print("unable to get context data")
            return
        }
        
        let pixelBuffer = buffer.bindMemory(to: RGBA32.self, capacity: width * height)
        
        for column in 0..<Int(width) {
            for row in 0..<Int(height) {
                if pixelBuffer[getCurrentPixelPosition(y: row, width: width, x: column)] == .red {
                    allNodesInMarket.append(Node(name: nodesCounter, xPosition: column, yPosition: row))
                    pixelsOfAllNodes[nodesCounter] = CGPoint(x: column, y: row)
                    nodesCounter += 1
                }
            }
        }
        
        for i in 0..<allNodesInMarket.count {
            
            let pX = allNodesInMarket[i].getXPosition()
            let pY = allNodesInMarket[i].getYPosition()
            
            var nextX = pX
            var nextY = pY
            
            
            // In positiver x-Richtung nach Node suchen
            while (nextX + 1) < inputCGImage.width {
                
                nextX += 1
                
                if pixelBuffer[getCurrentPixelPosition(y: pY, width: width, x: nextX)] == RGBA32.red {
                    allNodesInMarket[i].addConnectedNode(node: getNodesByCoordinate(x: nextX, y: pY))
                    break
                }else if pixelBuffer[getCurrentPixelPosition(y: pY, width: width, x: nextX)] == RGBA32.white {
                    break
                }
            }
            
            //In positiver y-Richtung nach Node suchen
            while nextY + 1 < inputCGImage.height {
                
                nextY += 1
                
                if pixelBuffer[getCurrentPixelPosition(y: nextY, width: width, x: pX)] == RGBA32.red {
                    allNodesInMarket[i].addConnectedNode(node: getNodesByCoordinate(x: pX, y: nextY))
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
                    allNodesInMarket[i].addConnectedNode(node: getNodesByCoordinate(x: nextX, y: pY))
                    break
                }else if pixelBuffer[getCurrentPixelPosition(y: pY, width: width, x: nextX)] == RGBA32.white {
                    break
                }
            }
            
            
            // In negativer y-Richutng nach Node suchen
            while nextY - 1 < inputCGImage.height && nextY - 1 > 0{
                
                nextY -= 1
                
                if pixelBuffer[getCurrentPixelPosition(y: nextY, width: width, x: pX)] == RGBA32.red {
                    allNodesInMarket[i].addConnectedNode(node: getNodesByCoordinate(x: pX, y: nextY))
                    break
                }else if pixelBuffer[getCurrentPixelPosition(y: nextY, width: width, x: pX)] == RGBA32.white {
                    break
                }
            }
            //            print("Knoten \(i) hat folgende Nachbarknoten: \(allNodesInMarket[i].getConnectedNodes())")
        }
        
    }
    
    func getCurrentPixelPosition(y row: Int, width: Int, x column: Int) -> Int {
        return row * width + column
    }
    
    func getNodesByCoordinate(x: Int, y: Int) -> Int {
        
        for i in 0..<allNodesInMarket.count {
            
            if allNodesInMarket[i].getXPosition() == x && allNodesInMarket[i].getYPosition() == y {
                return i
            }
        }
        return 0
    }
    
    mutating func loadRoutes(){
        
        //READ Textfile
        if let path = Bundle.main.path(forResource: "AllRoutes", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let lines: [String] = data.components(separatedBy: .newlines)
                var tempNodeArray = [Node]()
                
                for line in lines{
                    
                    for nodeNumber in line.split(separator: ","){
                        tempNodeArray.append(allNodesInMarket[Int(nodeNumber)!])
                    }
                    
                    finalRoutes.append(Route(nodes: tempNodeArray))
                    tempNodeArray = [Node]()
                    
                }
            } catch {
                print(error.localizedDescription)
            }
        }else{
            // @FRANK warum, die Datei ist doch sicher vorhanden?
        }
    }
    
    func getAllNodes() -> [Node] {
        return allNodesInMarket
    }
    
    func getRouteToItem(i: Int) -> Route{
        return finalRoutes[i]
    }
    
    func isInRoute(node: Node) -> Bool{
        
        if nodesInRoute.contains(node){
            return true
        }else{
            return false
        }
    }
    
    mutating func nextNode(currentNode: Int){
        
        nodesInRoute.append(allNodesInMarket[currentNode])
        
        if allNodesInMarket[currentNode].getConnectedNodes().count > 1 {
            
            for i in 0..<allNodesInMarket[currentNode].getConnectedNodes().count{
                
                if allNodesInMarket[currentNode].getConnectedNodes()[i] == end{
                    
                    //Zielknoten gefunden
                    
                    nodesInRoute.append(allNodesInMarket[Int(allNodesInMarket[currentNode].getConnectedNodes()[i])])
                    routesToItem.append(Route(nodes: nodesInRoute))
                    nodesInRoute.remove(at: nodesInRoute.count - 1)
                    
                    continue
                }
                
                if isInRoute(node: allNodesInMarket[Int(allNodesInMarket[currentNode].getConnectedNodes()[i])]) {
                    //Knoten bereits in der Route
                }else{
                    //Knoten noch ncht in der Route
                    nextNode(currentNode: Int(allNodesInMarket[currentNode].getConnectedNodes()[i]))
                }
            }
            
            nodesInRoute.remove(at: nodesInRoute.count - 1)
        }else {
            
            //Konten hat nur einen möglichen Folgeknoten
            
            if (allNodesInMarket[currentNode].getConnectedNodes()[0] == end){
                
                nodesInRoute.append(allNodesInMarket[Int(allNodesInMarket[currentNode].getConnectedNodes()[0])])
                routesToItem.append(Route(nodes: nodesInRoute))
                nodesInRoute.remove(at: nodesInRoute.count - 1)
                
                return
            }
            
            if isInRoute(node: allNodesInMarket[Int(allNodesInMarket[currentNode].getConnectedNodes()[0])]) {
                //Knoten bereits in der Route
            }else{
                //Knoten noch ncht in der Route
                nextNode(currentNode: Int(allNodesInMarket[currentNode].getConnectedNodes()[0]))
            }
        }
        
        
    }
    
    func getShortestRoute() -> Route {
        
        var index = 0
        let distance = routesToItem[0].getLength()
        
        for i in 0..<routesToItem.count {
            
            if routesToItem[i].getLength() < distance {
                index = i
            }
        }
        return routesToItem[index]
    }
    
    func getDrawPixelCoordinates() -> [CGPoint]{
        return drawCoordinateDictionary
    }
    
    
    //Funktion um eine Route ins Bild einzuzeichnen
    mutating func drawRouteIntoMarketPlan(route: Route) -> UIImage?{
        
        guard let inputCGImage = bitMapMarketPlan2D?.cgImage else {
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
        let outputImage = UIImage(cgImage: outputCGImage, scale: bitMapMarketPlan2D!.scale, orientation: bitMapMarketPlan2D!.imageOrientation)
        
        return outputImage
    }
    
}
