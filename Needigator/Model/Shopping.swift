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
    
    static func updateSelectedItemsInModel(for article: Article, with amount: Int, with operation: Modification? = nil){

        if operation == nil {
            Shopping.selectedProductsOfUser[article] = amount
        }else if operation == Modification.increase{
            Shopping.selectedProductsOfUser[article] = Shopping.selectedProductsOfUser[article]! + 1
        }else if operation == Modification.decrease{
            Shopping.selectedProductsOfUser[article] = Shopping.selectedProductsOfUser[article]! - 1
        }
    }
}
