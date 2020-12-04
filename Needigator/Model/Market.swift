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
    static var bitMapMarketPlan2D = UIImage(named: "NODES_1242x1065_colored TEST")
    static var allNodesInMarket = [Node]()
    static var coordinatesOfInformationButton = [Int : (CGPoint, RGBA32)]()
    var pathsToRoutesFile: String = "AllRoutes.txt"
    static var finalRoutes = [Route]()
    private var routesToItem: [Route] = [Route]()
    private var nodesInRoute: [Node] = [Node]()
    
    
    init() {
        //Hard coded Information-Button Position in Route VC
        Market.coordinatesOfInformationButton[1] = (CGPoint(x: 286, y: 524), RGBA32(red: 0xfc, green: 0xdd, blue: 0x93, alpha: 0xff))
        Market.coordinatesOfInformationButton[2] = (CGPoint(x: 286, y: 730), RGBA32(red: 0xbb, green: 0xbf, blue: 0xff, alpha: 0xff))
        Market.coordinatesOfInformationButton[3] = (CGPoint(x: 293, y: 119), RGBA32(red: 0xb2, green: 0xde, blue: 0xec, alpha: 0xff))
        Market.coordinatesOfInformationButton[4] = (CGPoint(x: 94, y: 250), RGBA32(red: 0xf5, green: 0x6a, blue: 0x78, alpha: 0xff))
        Market.coordinatesOfInformationButton[5] = (CGPoint(x: 548, y: 100), RGBA32(red: 0xeb, green: 0xcf, blue: 0xc4, alpha: 0xff))
        Market.coordinatesOfInformationButton[6] = (CGPoint(x: 895, y: 98), RGBA32(red: 0xa1, green: 0xe6, blue: 0xe3, alpha: 0xff))
        Market.coordinatesOfInformationButton[7] = (CGPoint(x: 914, y: 639), RGBA32(red: 0xb8, green: 0xcb, blue: 0x8b, alpha: 0xff))
        Market.coordinatesOfInformationButton[8] = (CGPoint(x: 537, y: 978), RGBA32(red: 0x55, green: 0x55, blue: 0x55, alpha: 0xff))
        
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
