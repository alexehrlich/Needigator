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
    
    //Notification wenn das Model Shopping (Ausgewählte Produkte) verändert wird:
    static let updatedSelectedProductDB = Notification.Name("gefehrlich.Needigator.SelectedArticlesUpdated")
    
    //Notfication, wenn in dem CardView die Anzahl geändert wird
    static let changeProductAmountinCardViewCell = Notification.Name("gefehrlich.Needigator.ChangeProductAmountinCardViewCell")


    
}
