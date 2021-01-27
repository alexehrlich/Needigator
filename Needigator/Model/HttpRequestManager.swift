//
//  HttpRequestManager.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 26.01.21.
//  Copyright © 2021 Alexander Ehrlich. All rights reserved.
//

import Foundation

protocol HttpRequestManagerDelegate {
    func didFinishWithRequest(result: Bool)
}

struct HttpRequestManager {
    
    var delegate : HttpRequestManagerDelegate?
    
    
    
    func postProductRequest(for product: String){
        // Prepare URL
        let urlString = "https://r0x77mivr9.execute-api.eu-central-1.amazonaws.com/prod/putfeedbackdata?content=" + product
        let url = URL(string: urlString)
        
        guard let requestUrl = url else {
            delegate?.didFinishWithRequest(result: false)
            return
        }
        
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
         
        // Perform HTTP Request
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.timeoutIntervalForResource = 2

        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) {(data, response, error) in
                
                // Check for Error
                if let error = error {
                    delegate?.didFinishWithRequest(result: false)
                    print("Error took place \(error)")
                    return
                }
            
                // Convert HTTP Response Data to a String
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    delegate?.didFinishWithRequest(result: true)
                    print("Response data string:\n \(dataString)")
                }
        }
        task.resume()
    }
}
