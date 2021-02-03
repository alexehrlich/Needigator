//
//  Shopping.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 25.10.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import Foundation

class  Shopping {
    
    enum Modification {
        
        case increase
        case decrease
    }
    
    static let shared = Shopping()
    
    var selectedProductsOfUser = [Article : Int]() {
        didSet{
            NotificationCenter.default.post(Notification(name: Messages.updatedSelectedProductDB, object: nil, userInfo: nil))
        }
    }
    
    var favoriteShoppingLists = [String : [Article : Int]]()
    var totalPrice: Double {
        
        get{
            var total: Double = 0.0
            for (article, amount) in selectedProductsOfUser {
                let convertedPrice = article.getCurrentPrice().replacingOccurrences(of: ",", with: ".").replacingOccurrences(of: "€", with: "")
                total += Double(convertedPrice)! * Double(amount)
            }
            return total
        }
    }
    
    var checkedProducts = Set<String>()
    
    func updateSelectedItemsInModel(for article: Article, with amount: Int, with operation: Modification? = nil){

        if operation == nil {
            Shopping.shared.selectedProductsOfUser[article] = amount
        }else if operation == Modification.increase{
            Shopping.shared.selectedProductsOfUser[article] = Shopping.shared.selectedProductsOfUser[article]! + 1
        }else if operation == Modification.decrease{
            
            if selectedProductsOfUser[article] == 1 {
                Shopping.shared.selectedProductsOfUser.removeValue(forKey: article)
            }else{
                Shopping.shared.selectedProductsOfUser[article] = Shopping.shared.selectedProductsOfUser[article]! - 1
            }
        }
    }
}
