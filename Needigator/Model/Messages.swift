//
//  Messages.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 27.10.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import Foundation

struct Messages {
    
    //Notofication wenn in der Produkttabelle gescrollt wird
    static let notificationNameForSearchTableVC = Notification.Name("gefehrlich.Needigator.dataForSearchTableVC")
    
    //Notofication wenn in der Produkttabelle getippt wird
    static let notificationNameForTappedProductCard = Notification.Name("gefehrlich.Needigator.productCardTapped")
    
    //Notification wenn das Model Shopping (Ausgewählte Produkte) verändert wurde:
    static let updatedSelectedProductDB = Notification.Name("gefehrlich.Needigator.SelectedArticlesUpdated")
    
    //Notificartion wenn der Add-Button auf der Produktkarte getippt wird und dann kurz die User-Interaction gesperrt werden soll
    static let addProductToList = Notification.Name("gefehrlich.Needigator.addProductToList")
    
}
