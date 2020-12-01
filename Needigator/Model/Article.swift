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
    private var amount: String //kg, ml
    private var node: Int
    private var price: String
    private var image: UIImage
    var isOnOffer: Bool
    var offerPrice : String?

    
    //Die Daten eines Artikels sind durch Unterstriche im Bildname enthalten. Hier wird der Bildname zerlegt und die Daten extrahiert.
    init(imageFileName: String) {
        
        let shortenedString = imageFileName.replacingOccurrences(of: ".png", with: "")
        let splittedString = shortenedString.split(separator: "_")
        
        name = String(splittedString[0])
        amount = String(splittedString[1])
        node = Int(String(splittedString[2])) ?? 74
        price = String(splittedString[3]) + "€"
        isOnOffer = splittedString[4] == "YES" ? true : false
        offerPrice = String(splittedString[5]) + "€"
        image = UIImage(named: imageFileName.replacingOccurrences(of: "_ _", with: "__"))!
    }
    

    
    //MARK: Getter-Methoden 
    func getName() -> String {
        return name
    }
    
    func getOfficialPrice() -> String {
        return price
    }
    
    func getCurrentPrice() -> String{
        return isOnOffer ? offerPrice! : price
    }
    
    func getImage() -> UIImage {
        return image
    }
    
    func getAmount() -> String {
        return amount
    }
    
    func getNode() -> Int {
        return node
    }
}

