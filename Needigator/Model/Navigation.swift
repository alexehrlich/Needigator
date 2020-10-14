//
//  Navigation.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 21.03.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit

protocol ImageTransfer {
    func receiveImage(image: UIImage)
    func receiveImagePixelData(points: [CGPoint])
}

protocol CalculationComplete {
    func didFinishWithCalculation()
}

struct Navigation {

    var market = Market()
    
    //Damit das Bild mit der Route an den RouteVC gesendet werden und dort angezeigt werden kann
    var delegate: ImageTransfer?
    var calculationDelegate: CalculationComplete?
    
    
    //SIMULATED ANNEALING
    var sigma: Double = 10000
    let sigmaReduktion = 0.001
    
    
    //In dieser Methode wird durch eine andere Methode die Route berechnet und deren Umsetzung in ein Bild initiiert
    mutating func drawImage(nodes: [Int]) {
        
        var routeNodes = [Node]()
        
        for nodeNumber in nodes {
            
        routeNodes.append(market.allNodesInMarket[nodeNumber])
        }
        
        let shuffeledRoute = Route(nodes: routeNodes.shuffled())
        
        //Lösche alle doppelt vorkommenden Produktzielknoten. Verschiedene Produkte können sich am gleichen Zielknoten befinden.
        let doubleDeletedRoute = deleteDuplicateNodes(route: shuffeledRoute)
        
        let optimizedRoute = simulatedAnnealing(for: doubleDeletedRoute)
        
        //erzeugt aus der Liste der Zielknoten der kürzesten Route die Liste die alle Knoten enthält - auch die zwischen den Zielknoten. Diese Knotenliste wird dann zum Zeichnen benötigt.
        let finalAppendedRoute = createCompleteRoute(route: optimizedRoute)
        
        
        //Beauftragt den Delegate dieser Klasse das errechnete Zielbild zu laden.
        delegate?.receiveImage(image: market.drawTestRoute(route: finalAppendedRoute)!)
        
        //Sendet die Pixel in der Route an den Routing VC
        delegate?.receiveImagePixelData(points: market.getDrawPixelCoordinates())
        
    }
    
    //Funktion die gleiche Endknoten aus der Liste löscht. Die zurückgegebene Route hat die Reihenfolge der Auswahl des Nutzers (zufaellig) und hat als ersten Knoten den Eingang hinzugefügt und als letzten Knoten die KAssse hinzugefügt
    func deleteDuplicateNodes(route: Route) -> Route {
        
        let tempNodeList = route.nodeList
        
        //Die neue Liste soll mit 74 beginnen, da hier der Eingang ist
        var filteredTempNodeList = [market.allNodesInMarket[74]]
        
        //Wenn der Knoten noch nicht in der gefilterten Liste ist, soll er angehaengt werden
        for node in tempNodeList {
            
            if !filteredTempNodeList.contains(node) && node != market.allNodesInMarket[64] {
                filteredTempNodeList.append(node)
            }
        }
        
        // Zum Schluss soll der Kassenknoten noch angehängt werden
        filteredTempNodeList.append(market.allNodesInMarket[64])
    
        return Route(nodes: filteredTempNodeList)
    }
    
    
    //Dise Funktion berrechnet die kürzeste Route nach dem Simulated Annealing Verfahren und gibt diese Route zurück.
    mutating func simulatedAnnealing(for route: Route) -> Route {
        
        
        var currentRoute = route
        var tempRoute = route
        var tradeNode1: Node?
        var tradeNode2: Node?
        var index1 = 0
        var index2 = 0
        
        
        //Abfrage, ob nur ein Artikel (3, da Kasse udn Eingang hinzukommen) gewählt wurde
        if route.getRoute().count == 3 {

            createCompleteRoute(route: route).showRoute()
            return route
        }else{
            while sigma > 0.5{
                
                //Index für den Tausch bestimmen, dieser kann nicht das erste oder das letzte Element sin, da die Kasse und der Eingang fix sind
                index1 = Int.random(in: 1..<tempRoute.getRoute().count - 1)
                index2 = Int.random(in: 1..<tempRoute.getRoute().count - 1)
                
                while index2 == index1 {
                    index2 = Int.random(in: 1..<tempRoute.getRoute().count - 1)
                }
                
                //Bestimme die zu tauschenden Knoten an den errechneten Indexen
                tradeNode1 = currentRoute.getRoute()[index1]
                tradeNode2 = currentRoute.getRoute()[index2]
                
                
                //Tausche die Knoten
                tempRoute.changeNodes(position: index1, node: tradeNode2!)
                tempRoute.changeNodes(position: index2, node: tradeNode1!)
                
           
                //Erstelle eine Liste aller abzulaufenden Knoten anhand der Produktknoten
                var distanceFromOldRoute = createCompleteRoute(route: currentRoute)
                var distanceFromNewRoute = createCompleteRoute(route: tempRoute)
            
                
                //Wenn der der Tausch von der Funktion nicht akzeptiert wird, wird wieder zurückgetauscht
                if !acceptingChangeOfRoutes(oldRouteDistance: distanceFromOldRoute.calculateDistance(), newRouteDistance: distanceFromNewRoute.calculateDistance(), sigma: Double(sigma)){
                    tempRoute.changeNodes(position: index1, node: tradeNode1!)
                    tempRoute.changeNodes(position: index2, node: tradeNode2!)
                    //                print("Tausch rückgängig gemacht")
                    
                    //Wenn die Route mit dem Tausch akzeptiert wird, dann setzte die aktuelle Route gleich der Route mit dem Wechsel der Knoten
                }else{
                    //                print("Tausch akzeptiert")
                    currentRoute = tempRoute
                }
                
                //Verringere Sigma
                sigma *= 1-sigmaReduktion
            }
            
            //print("Die optimierte Route ist: ")
            calculationDelegate?.didFinishWithCalculation()
            currentRoute.showRoute()
            return currentRoute
        }
        
    }
    
    //Diese Funktion erzeigt aus der Route, die nur die Zielknoten enthält, die endgültige Route mit alle Knoten die zwischen den Zielknoten liegen. Diese Route ist dann auch tatsächlich laufbar, da von jedem Knoten der Folgeknoten erreicht werden kann.
    func createCompleteRoute(route: Route) -> Route {
        
        var tempNodeArray = [market.allNodesInMarket[74]]
        
        for i in 0..<route.getRoute().count {
            
            
            
            //Folgende Abfrage ist für den Zugriff auf AllRoutes.txt notwendig. Liegt der ist der Folgeknoten kleiner als Knoten, gilt eine andere Berechnung füpr den Zugriff auf das Array, wie wenn der Folgeknoten größer als der Knoten ist.
            if i < route.getRoute().count - 1 {
                
                if route.getRoute()[i].getNodeName() < route.getRoute()[i + 1].getNodeName() {
                    
                    //Berechnung des Index
                    let index = route.getRoute()[i].getNodeName() * 95 + route.getRoute()[i + 1].getNodeName() - 1
                    var partWay = market.finalRoutes[index].getRoute()
                    
                    //Das erste Element wird gelöscht, da es schon als Knoten der vorherigen Subroute enthalten ist.
                    partWay.removeFirst()
                    
                    //Hänge die Subroute an
                    tempNodeArray += partWay
                    
                }else{
                    //Berechnung des Index (anders!)
                    let index = route.getRoute()[i].getNodeName() * 95 + route.getRoute()[i + 1].getNodeName()
                    var partWay = market.finalRoutes[index].getRoute()
                    
                    //Das erste Element wird gelöscht, da es schon als Knoten der vorherigen Subroute enthalten ist.
                    partWay.removeFirst()
                    
                    //Hänge die Subroute an
                    tempNodeArray += partWay
                }
                
            }
        }
        
        let finalRoute = Route(nodes: tempNodeArray)
        return finalRoute
    }
    
    
    
    //Prüft, ob der Tausch akzepiert werden kann
    func acceptingChangeOfRoutes(oldRouteDistance: Int, newRouteDistance: Int, sigma: Double) -> Bool{
        
        let delta: Double = Double(newRouteDistance - oldRouteDistance)
        let exponent: Double = -(delta/sigma)
        let calc = pow(M_E, exponent)
        
        //Wenn die neue Distanz geringer als die vorherige ist, tasuche sofort
        if newRouteDistance < oldRouteDistance {
            return true
            
        //Wenn die neue Distanz größer ist, dann bestimme die Akzeptanz, ob sie trotzdem genommen werden soll
        }else{
            
            let randomDouble = Double.random(in: 0...1)
            if calc > randomDouble{
                return true
            }else {
                return false
            }
        }
    }
}
