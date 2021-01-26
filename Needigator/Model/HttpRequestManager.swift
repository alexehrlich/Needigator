//
//  HttpRequestManager.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 26.01.21.
//  Copyright © 2021 Alexander Ehrlich. All rights reserved.
//

import Foundation

struct HttpRequestManager {
    
   
    
    func postProductRequest(for product: String){
        // Prepare URL
        let urlString = "https://r0x77mivr9.execute-api.eu-central-1.amazonaws.com/prod/putfeedbackdata?content=" + product
        let url = URL(string: urlString)
        
        guard let requestUrl = url else { return }
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
         
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
                
                // Check for Error
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
            
                // Convert HTTP Response Data to a String
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("Response data string:\n \(dataString)")
                }
        }
        task.resume()
    }
}
