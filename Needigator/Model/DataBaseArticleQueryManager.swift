//
//  DataBaseArticleQueryManager.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 22.01.21.
//  Copyright © 2021 Alexander Ehrlich. All rights reserved.
//

import Foundation

protocol DataBaseArticleQueryManagerDelegate{
    func didFinishWithDownloadFromDb()
}

struct DataBaseArticleQueryManager {
    
    //Networking
    
    //1. Create URL-Object
    //2. Create URLSession, objects that does the networking
    //3. Give URLSession a task
    //4. start the task
    
    
    let accessURL = "https://r0x77mivr9.execute-api.eu-central-1.amazonaws.com/prod/getdynamodata"
    
    var delegate: DataBaseArticleQueryManagerDelegate!
    
    func getProducts(){
        performRequest(urlString: accessURL)
    }
    
    func performRequest(urlString: String){
        
        //Create URL, creates an optional
        if let url = URL(string: urlString){
            
            //Create URLSession
            let urlSession = URLSession(configuration: .default)
            
            //Give the session a task
            let task = urlSession.dataTask(with: url) { (data, respone, error) in
                guard error == nil else { return }
                
                if let safeData = data {
                    self.parseJSON(for: safeData)
                }
                
                //Finished Downloading
                delegate.didFinishWithDownloadFromDb()
            }
            //start the task
            task.resume()
        }
    }
    
    func parseJSON(for data: Data){
        
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(JsonArticles.self, from: data)
            
            for data in decodedData.Items{
                let article = Article(name: data.Name.S, price: (data.Preis.S + "€"), amount: data.Menge.S, node: Int(data.Knoten.S)!, isOnOffer: data.ImAngebot.BOOL, offerPrice: (data.Angebotspreis.S + "€"))
                
                if !ArticleDataBase.items.contains(article){
                    ArticleDataBase.items.append(article)
                }
                
            }
        }catch{
            print("ERROR:\n")
            print(error)
        }
    }
}
