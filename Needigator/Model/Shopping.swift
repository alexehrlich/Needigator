//
//  Shopping.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 25.10.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import Foundation

struct  Shopping {
    
    enum Modification {
        
        case increase
        case decrease
    }
    
    static var selectedProductsOfUser = [Article : Int]() {
        didSet{
            NotificationCenter.default.post(Notification(name: Messages.updatedSelectedProductDB, object: nil, userInfo: nil))
        }
    }
    
    static var favoriteShoppingLists = [String : [Article : Int]]()
    static var totalPrice: Double {
        
        get{
            var total: Double = 0.0
            for (article, amount) in selectedProductsOfUser {
                let convertedPrice = article.getCurrentPrice().replacingOccurrences(of: ",", with: ".").replacingOccurrences(of: "€", with: "")
                total += Double(convertedPrice)! * Double(amount)
            }
            return total
        }
    }
    
    static var checkedProducts = Set<String>()
    
    static func updateSelectedItemsInModel(for article: Article, with amount: Int, with operation: Modification? = nil){

        if operation == nil {
            Shopping.selectedProductsOfUser[article] = amount
        }else if operation == Modification.increase{
            Shopping.selectedProductsOfUser[article] = Shopping.selectedProductsOfUser[article]! + 1
        }else if operation == Modification.decrease{
            
            if selectedProductsOfUser[article] == 1 {
                Shopping.selectedProductsOfUser.removeValue(forKey: article)
            }else{
                Shopping.selectedProductsOfUser[article] = Shopping.selectedProductsOfUser[article]! - 1
            }
        }
    }
}
