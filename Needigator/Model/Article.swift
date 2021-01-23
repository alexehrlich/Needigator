//
//  Article.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 15.03.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit

struct Article: Hashable {
    
    var description: String = ""
    var isVegan: Bool = false
    var isOnOffer: Bool
    var image = UIImage(named: "no-image-available")
    var shelfLevel: String = ""
    var shelfArea: String = ""
    var offerPrice : String? = nil
    var productCategory: String = ""
    var ean: String = ""
    var name: String
    var amount: String
    var node: Int
    var price: String
    
    init(name: String, price: String, amount: String, node: Int, isOnOffer: Bool, offerPrice: String?) {
        self.name = name
        self.price = price
        self.amount = amount
        self.node = node
        self.isOnOffer = isOnOffer
        self.offerPrice = offerPrice
    }
    
  

    
    //Die Daten eines Artikels sind durch Unterstriche im Bildname enthalten. Hier wird der Bildname zerlegt und die Daten extrahiert.

    

    
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
        return image!
    }
    
    func getAmount() -> String {
        return amount
    }
    
    func getNode() -> Int {
        return node
    }
}

