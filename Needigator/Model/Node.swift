//
//  Node.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 21.03.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import Foundation

struct Node: Equatable {
    
    var name: Int
    var xPosition: Int
    var yPosition: Int
    
    private var connectedNodes = [Int]()
    
    init(name: Int, xPosition: Int, yPosition: Int) {
        self.name = name
        self.xPosition = xPosition
        self.yPosition = yPosition
    }
    
    func getNodeName() -> Int {
        return name
    }
    
    mutating func addConnectedNode(node: Int) {
        connectedNodes.append(node)
    }
    
    func showConnectedNodes() -> String{
        
        var connectionInfo = String(name) + "is connected with "
        
        for node in connectedNodes{
            connectionInfo += String(node) + "and"
        }
        return connectionInfo
    }
    
    func getConnectedNodes() -> [Int] {
        return connectedNodes
    }
    
    func getXPosition() -> Int {
        return xPosition
    }
    
    func getYPosition() -> Int {
        return yPosition
    }
    
}
