//
//  Article.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 15.03.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit

struct Article {
    
    private var name: String
    private var info: String
    private var node: Int
//    private var category: String
    private var price: String
    private var image: UIImage
    
    init(imageFileName: String) {
        
        let shortenedString = imageFileName.replacingOccurrences(of: ".png", with: "")
        let splittedString = shortenedString.split(separator: "_")
        
        name = String(splittedString[0])
        info = String(splittedString[1])
        node = Int(String(splittedString[2])) ?? 74
        price = String(splittedString[3]) + "€"
        image = UIImage(named: imageFileName.replacingOccurrences(of: "_ _", with: "__"))!
    }
    
    
    func getName() -> String {
        return name
    }
    
    func getPrice() -> String {
        return price
    }
    
    func getImage() -> UIImage {
        return image
    }
    
    func getInfo() -> String {
        return info
    }
    
    func getNode() -> Int {
        return node
    }
    //    func getCategory() -> String {
    //        return category
    //    }
}

