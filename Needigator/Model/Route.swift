//
//  Route.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 21.03.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import Foundation

struct Route {
    
    var nodeList = [Node]()
    var length: Int = 0
    
    init(nodes: [Node]) {
        for i in 0..<nodes.count {
            nodeList.append(nodes[i])
        }
        //        calculateDistace()
    }
    
    func getLength() -> Int {
        return length
    }
    
    mutating func calculateDistance() -> Int{
        
        for i in 0..<nodeList.count {
            
            if i < nodeList.count - 1 {
                let x_n = Double(nodeList[i].getXPosition())
                let x_nPlus1 = Double(nodeList[i + 1].getXPosition())
                let y_n = Double(nodeList[i].getYPosition())
                let y_nPlus1 = Double(nodeList[i + 1].getYPosition())
            
                length += Int(sqrt(pow(x_nPlus1 - x_n, 2) + pow(y_nPlus1 - y_n, 2)))
            }
        }
        
        return length
    }
    
    func getRoute() -> [Node]{
        return nodeList
    }
    
    func showRoute() {
        print("Aktuelle Knoten in Route")
        
        for i in 0..<nodeList.count {
            print(nodeList[i].getNodeName())
        }
    }
    
    mutating func changeNodes(position: Int, node: Node){
        nodeList[position] = node
    }
}
