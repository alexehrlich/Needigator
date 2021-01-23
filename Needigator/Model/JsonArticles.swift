//
//  JsonArticle.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 22.01.21.
//  Copyright © 2021 Alexander Ehrlich. All rights reserved.
//

import Foundation


struct JsonArticles: Decodable{
    var Count: Int
    var Items: [Item]
}

struct Item: Decodable {
    
    var Beschreibung: StringData
    var Vegan: BoolData
    var ImAngebot: BoolData
    var BildUrl: StringData
    var Regalebene: StringData
    var Regalbereich: StringData
    var Angebotspreis: StringData
    var Produktkategorie: StringData
    var EAN: StringData
    var Menge: StringData
    var Knoten: StringData
    var Regional: BoolData
    var Preis: StringData
    var Name: StringData

}

struct StringData: Decodable{
    var S: String
}

struct BoolData: Decodable{
    var BOOL: Bool
}


