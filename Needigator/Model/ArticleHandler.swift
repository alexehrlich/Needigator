//
//  ArticleHandler.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 17.03.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import Foundation

struct ArticleHandler {
    
    let testDataBase = ArticleDataBase()
    
    func checkSubstringInArticle(substring: String) -> [Article] {
        var articleArray = [Article]()
            
            //Es soll erst nach 3 Buchstaben geschaut werden, sonst zeigt er ja alles an.
            if substring.count >= 3 {
    
                for article in testDataBase.items {
                
                    if article.getName().lowercased().contains(substring.lowercased()){
                        print(article.getName())
                        articleArray.append(article)
                    }
                }
            }
        return articleArray
    }
    
}
