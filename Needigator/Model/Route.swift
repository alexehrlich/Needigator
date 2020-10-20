//
//  Route.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 21.03.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import Foundation

struct Route {
    
    private var nodeList = [Node]()
    private var length: Int = 0
    
    init(nodes: [Node]) {
        for i in 0..<nodes.count {
            nodeList.append(nodes[i])
        }
    }
    
    func getLength() -> Int {
        return length
    }
    

    mutating func calculateDistance() -> Int{
        
        for i in 0..<nodeList.count {
            
            if i < nodeList.count - 1 {
                let xPositionCurrentNode = Double(nodeList[i].getXPosition())
                let xPositionNextNode = Double(nodeList[i + 1].getXPosition())
                let yPositionCurrentNode = Double(nodeList[i].getYPosition())
                let yPositionNextNode = Double(nodeList[i + 1].getYPosition())
            
                length += Int(sqrt(pow(xPositionNextNode - xPositionCurrentNode, 2) + pow(yPositionNextNode - yPositionCurrentNode, 2)))
            }
        }
        return length
    }
    
    func getListOfNodesInRoute() -> [Node]{
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
