//
//  Article.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 15.03.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit

struct Article: Hashable {
    
    private var name: String
    private var info: String
    private var node: Int
    private var price: String
    private var image: UIImage

    
    //Die Daten eines Artikels sind durch Unterstriche im Bildname enthalten. Hier wird der Bildname zerlegt und die Daten extrahiert.
    init(imageFileName: String) {
        
        let shortenedString = imageFileName.replacingOccurrences(of: ".png", with: "")
        let splittedString = shortenedString.split(separator: "_")
        
        name = String(splittedString[0])
        info = String(splittedString[1])
        node = Int(String(splittedString[2])) ?? 74
        price = String(splittedString[3]) + "€"
        image = UIImage(named: imageFileName.replacingOccurrences(of: "_ _", with: "__"))!
    }
    
    //MARK: Getter-Methoden 
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
}

