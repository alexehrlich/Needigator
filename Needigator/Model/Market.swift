//
//  Market.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 31.03.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit

//Market wird als Klasse gemacht, da es nur einen Markt gibt. Beim Übergeben des market-objekted ist es also immer dasselbe -->call by refernece
class Market {
    
    var end = 0
    static var bitMapMarketPlan2D = UIImage(named: "NODES_1242x1065_colored")
    static var allNodesInMarket = [Node]()
    var pathsToRoutesFile: String = "AllRoutes.txt"
    static var finalRoutes = [Route]()
    private var routesToItem: [Route] = [Route]()
    private var nodesInRoute: [Node] = [Node]()
    
    
    init() {
        
    }
    
    
    func getAllNodes() -> [Node] {
        return Market.allNodesInMarket
    }
    
    func getRouteToItem(i: Int) -> Route{
        return Market.finalRoutes[i]
    }
    
    func isInRoute(node: Node) -> Bool{
        
        if nodesInRoute.contains(node){
            return true
        }else{
            return false
        }
    }
    
    func nextNode(currentNode: Int){
        
        nodesInRoute.append(Market.allNodesInMarket[currentNode])
        
        if Market.allNodesInMarket[currentNode].getConnectedNodes().count > 1 {
            
            for i in 0..<Market.allNodesInMarket[currentNode].getConnectedNodes().count{
                
                if Market.allNodesInMarket[currentNode].getConnectedNodes()[i] == end{
                    
                    //Zielknoten gefunden
                    nodesInRoute.append(Market.allNodesInMarket[Int(Market.allNodesInMarket[currentNode].getConnectedNodes()[i])])
                    routesToItem.append(Route(nodes: nodesInRoute))
                    nodesInRoute.remove(at: nodesInRoute.count - 1)
                    
                    continue
                }
                
                if isInRoute(node: Market.allNodesInMarket[Int(Market.allNodesInMarket[currentNode].getConnectedNodes()[i])]) {
                    //Knoten bereits in der Route
                }else{
                    //Knoten noch ncht in der Route
                    nextNode(currentNode: Int(Market.allNodesInMarket[currentNode].getConnectedNodes()[i]))
                }
            }
            
            nodesInRoute.remove(at: nodesInRoute.count - 1)
        }else {
            
            //Konten hat nur einen möglichen Folgeknoten
            
            if (Market.allNodesInMarket[currentNode].getConnectedNodes()[0] == end){
                
                nodesInRoute.append(Market.allNodesInMarket[Int(Market.allNodesInMarket[currentNode].getConnectedNodes()[0])])
                routesToItem.append(Route(nodes: nodesInRoute))
                nodesInRoute.remove(at: nodesInRoute.count - 1)
                
                return
            }
            
            if isInRoute(node: Market.allNodesInMarket[Int(Market.allNodesInMarket[currentNode].getConnectedNodes()[0])]) {
                //Knoten bereits in der Route
            }else{
                //Knoten noch nicht in der Route
                nextNode(currentNode: Int(Market.allNodesInMarket[currentNode].getConnectedNodes()[0]))
            }
        }
    }
}
