//
//  Navigation.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 21.03.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import Foundation

protocol RouteCalculationManagerDelegate {
    func didFinishOptimizingRoute(result: Route)
//    func receiveImagePixelData(points: [CGPoint])
}


struct RouteCalculationManager {

    var market = Market()
    
    //SIMULATED ANNEALING CONSTANTS
    private var sigma: Double = 10000
    private let sigmaReduktion = 0.001
    
    //Damit das Bild mit der Route an den RouteVC gesendet werden und dort angezeigt werden kann
    var delegate: RouteCalculationManagerDelegate?
    
    //In dieser Methode wird durch eine andere Methode die Route berechnet und deren Umsetzung in ein Bild initiiert
    mutating func prepareRoute(nodes: [Int]) {
        
        var nodesInRoute = [Node]()
        
        for nodeNumber in nodes {
            nodesInRoute.append(Market.allNodesInMarket[nodeNumber])
        }
        
        let shuffeledRoute = Route(nodes: nodesInRoute.shuffled())
        
        //Lösche alle doppelt vorkommenden Produktzielknoten. Verschiedene Produkte können sich am gleichen Zielknoten befinden.
        let doubleDeletedRoute = deleteDuplicateNodes(route: shuffeledRoute)
        
        let optimizedRoute = calculateShortestRouteWithSimulatedAnnealing(for: doubleDeletedRoute)
        
        //erzeugt aus der Liste der Zielknoten der kürzesten Route die Liste die alle Knoten enthält - auch die zwischen den Zielknoten. Diese Knotenliste wird dann zum Zeichnen benötigt.
        let finalAppendedRoute = createCompleteRoute(route: optimizedRoute)
        
        //Beauftragt den Delegate dieser Klasse das errechnete Zielbild zu laden.
        delegate?.didFinishOptimizingRoute(result: finalAppendedRoute)
        
        //Sendet die Pixel in der Route an den Routing VC, damit die Route von den Einkaufswagen abgefahren werden kann.
        //delegate?.receiveImagePixelData(points: market.getDrawPixelCoordinates())
    }
}
   

//MARK: Route manipulating methods

extension RouteCalculationManager{
    //Diese Funktion erzeigt aus der Route, die nur die Zielknoten enthält, die endgültige Route mit alle Knoten die zwischen den Zielknoten liegen. Diese Route ist dann auch tatsächlich laufbar, da von jedem Knoten der Folgeknoten erreicht werden kann.
    private func createCompleteRoute(route: Route) -> Route {
        
        var tempNodeArray = [Market.allNodesInMarket[74]]
        
        for i in 0..<route.getListOfNodesInRoute().count {
            
            //Folgende Abfrage ist für den Zugriff auf AllRoutes.txt notwendig. Liegt der ist der Folgeknoten kleiner als Knoten, gilt eine andere Berechnung füpr den Zugriff auf das Array, wie wenn der Folgeknoten größer als der Knoten ist.
            if i < route.getListOfNodesInRoute().count - 1 {
                
                if route.getListOfNodesInRoute()[i].getNodeName() < route.getListOfNodesInRoute()[i + 1].getNodeName() {
                    
                    //Berechnung des Index
                    let index = route.getListOfNodesInRoute()[i].getNodeName() * 95 + route.getListOfNodesInRoute()[i + 1].getNodeName() - 1
                    var partWay = Market.finalRoutes[index].getListOfNodesInRoute()
                    
                    //Das erste Element wird gelöscht, da es schon als Knoten der vorherigen Subroute enthalten ist.
                    partWay.removeFirst()
                    
                    //Hänge die Subroute an
                    tempNodeArray += partWay
                    
                }else{
                    //Berechnung des Index (anders!)
                    let index = route.getListOfNodesInRoute()[i].getNodeName() * 95 + route.getListOfNodesInRoute()[i + 1].getNodeName()
                    var partWay = Market.finalRoutes[index].getListOfNodesInRoute()
                    
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
    
    //Funktion die gleiche Endknoten aus der Liste löscht. Die zurückgegebene Route hat die Reihenfolge der Auswahl des Nutzers (zufaellig) und hat als ersten Knoten den Eingang hinzugefügt und als letzten Knoten die KAssse hinzugefügt
    private func deleteDuplicateNodes(route: Route) -> Route {
        
        let tempNodeList = route.getListOfNodesInRoute()
        
        //Die neue Liste soll mit 74 beginnen, da hier der Eingang ist
        var filteredTempNodeList = [Market.allNodesInMarket[74]]
        
        //Wenn der Knoten noch nicht in der gefilterten Liste ist, soll er angehaengt werden
        for node in tempNodeList {
            
            if !filteredTempNodeList.contains(node) && node != Market.allNodesInMarket[64] {
                filteredTempNodeList.append(node)
            }
        }
        
        // Zum Schluss soll der Kassenknoten noch angehängt werden
        filteredTempNodeList.append(Market.allNodesInMarket[64])
    
        return Route(nodes: filteredTempNodeList)
    }
}


//MARK: Simulated Annelaing Algorithm

extension RouteCalculationManager {
    
    //Dise Funktion berrechnet die kürzeste Route nach dem Simulated Annealing Verfahren und gibt diese Route zurück.
    private mutating func calculateShortestRouteWithSimulatedAnnealing(for route: Route) -> Route {
        
        var currentRoute = route
        var tempRoute = route
        var tradeNode1: Node?
        var tradeNode2: Node?
        var index1 = 0
        var index2 = 0
        
        
        //Abfrage, ob nur ein Artikel (3, da Kasse udn Eingang hinzukommen) gewählt wurde
        if route.getListOfNodesInRoute().count == 3 {

            createCompleteRoute(route: route).showRoute()
            return route
        }else{
            while sigma > 0.5{
                
                //Index für den Tausch bestimmen, dieser kann nicht das erste oder das letzte Element sin, da die Kasse und der Eingang fix sind
                index1 = Int.random(in: 1..<tempRoute.getListOfNodesInRoute().count - 1)
                index2 = Int.random(in: 1..<tempRoute.getListOfNodesInRoute().count - 1)
                
                while index2 == index1 {
                    index2 = Int.random(in: 1..<tempRoute.getListOfNodesInRoute().count - 1)
                }
                
                //Bestimme die zu tauschenden Knoten an den errechneten Indexen
                tradeNode1 = currentRoute.getListOfNodesInRoute()[index1]
                tradeNode2 = currentRoute.getListOfNodesInRoute()[index2]
                
                
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
                    
                    //Wenn die Route mit dem Tausch akzeptiert wird, dann setzte die aktuelle Route gleich der Route mit dem Wechsel der Knoten
                }else{
                    currentRoute = tempRoute
                }
                
                //Verringere Sigma
                sigma *= 1-sigmaReduktion
            }
            return currentRoute
        }
        
    }
    
    //Prüft, ob der Tausch akzepiert werden kann
    private func acceptingChangeOfRoutes(oldRouteDistance: Int, newRouteDistance: Int, sigma: Double) -> Bool{
        
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

