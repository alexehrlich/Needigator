//
//  Navigation.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 21.03.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit

struct Navigation {
    
    private var end: Int = 0 // Was ist diese Variable
    private var pathsToRoutesFile: String = "routes.txt"
    private var allNodesInMarket: [Node] = [Node]()
    private var finalRoutes: [Route] = [Route]()
    private var routesToitem: [Route] = [Route]()
    private var nodesInRoute: [Node] = [Node]()
    
    private var bitMapImageOfNodes = UIImage(named: "knoten.png")
    private var depth: Int = 0 //Was macht dieser Variable
    
    init() {
        loadNodes()
        loadRoutes()
    }
    
    func calcRoutePerTick(tick: Int){
        //EMPTY
    }
    
    
    mutating func loadNodes(){
        
        var nodesCounter = 0
        
        guard let inputCGImage = bitMapImageOfNodes?.cgImage else {
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
            print("unable to create context")
            return
        }
        context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let buffer = context.data else {
            print("unable to get context data")
            return
        }
        
        let pixelBuffer = buffer.bindMemory(to: RGBA32.self, capacity: width * height)
        
        print("Bildgröße: \(width) * \(height)")
        for row in 0..<Int(height) {
            for column in 0..<Int(width) {
//                print("x: \(column), y: \(row)")
                if pixelBuffer[getCurrentPixelPosition(y: row, width: width, x: column)] == .red {
                    allNodesInMarket.append(Node(name: nodesCounter, xPosition: column, yPosition: row))
                    print("Knoten: \(nodesCounter), x: \(column), y: \(row)")
                    nodesCounter += 1
                }
            }
        }
        
        print("\(allNodesInMarket.count) Knoten gefunden.")
        
        for i in 0..<allNodesInMarket.count {
            
            let pX = allNodesInMarket[i].getXPosition()
            let pY = allNodesInMarket[i].getYPosition()
            
            var nextX = pX
            var nextY = pY
            
            
            // In positiver x-Richtung nach Node suchen
            while nextX + 1 < inputCGImage.width {
                
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
                    allNodesInMarket[i].addConnectedNode(node: getNodesByCoordinate(x: pX, y: pX))
                    break
                }else if pixelBuffer[getCurrentPixelPosition(y: nextY, width: width, x: pX)] == RGBA32.white{
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
                    allNodesInMarket[i].addConnectedNode(node: getNodesByCoordinate(x: pX, y: pX))
                    break
                }else if pixelBuffer[getCurrentPixelPosition(y: nextY, width: width, x: pX)] == RGBA32.white{
                    break
                }
            }
            
        }
    }
    
    mutating func loadRoutes(){
        
        //READ Textfile
        if let path = Bundle.main.path(forResource: "routes", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let lines: [String] = data.components(separatedBy: .newlines)
                var tempNodeArray = [Node]()
                
                print(allNodesInMarket.count)
                
                for line in lines {
                    for nodeNumber in line.split(separator: ","){
                        
                        print(nodeNumber)
                        
                        tempNodeArray.append(allNodesInMarket[Int(nodeNumber)!])
                    }
                    
                    finalRoutes.append(Route(nodes: tempNodeArray))
                }
            } catch {
                print(error.localizedDescription)
            }
            
            print("Alle Routen aus Datei geladen")
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
    
    mutating func startNavigation(startingPoint: Int, endPoint: Int) {
        
        routesToitem = [Route]()
        nodesInRoute = [Node]()
        self.end = endPoint
        
        nextNode(currentNode: startingPoint)
        
        finalRoutes.append(getShortestRoute())
        
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
            
            print("Knoten \(currentNode) ist mit mehr als einem Knoten verbunden")
            
            for i in 0..<allNodesInMarket[currentNode].getConnectedNodes().count{
                
                print("Nächster Knoten: \(allNodesInMarket[currentNode].getConnectedNodes()[i])")
                
                if allNodesInMarket[currentNode].getConnectedNodes()[i] == end{
                    
                    //Zielknoten gefunden
                    print("Zielknoten gefudnen")
                    
                    nodesInRoute.append(allNodesInMarket[Int(allNodesInMarket[currentNode].getConnectedNodes()[i])])
                    routesToitem.append(Route(nodes: nodesInRoute))
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
            print("Knoten \(currentNode) hat nur einen Folgekonten")
            
            if (allNodesInMarket[currentNode].getConnectedNodes()[0] == end){
                
                nodesInRoute.append(allNodesInMarket[Int(allNodesInMarket[currentNode].getConnectedNodes()[0])])
                routesToitem.append(Route(nodes: nodesInRoute))
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
    
    
    func getNodesByCoordinate(x: Int, y: Int) -> Int {
        
        for i in 0..<allNodesInMarket.count {
            
            if allNodesInMarket[i].getXPosition() == x && allNodesInMarket[i].yPosition == y {
                return i
            }
        }
        return 0
    }
    
    func getCurrentPixelPosition(y row: Int, width: Int, x column: Int) -> Int {
        return row * width + column
    }
    
    func getShortestRoute() -> Route {
        
        var index = 0
        let distance = routesToitem[0].getLength()
        
        for i in 0..<routesToitem.count {
            
            if routesToitem[i].getLength() < distance {
                index = i
            }
        }
        return routesToitem[index]
    }
}
