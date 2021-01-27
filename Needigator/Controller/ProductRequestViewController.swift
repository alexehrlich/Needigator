//
//  ProductRequestViewController.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 25.01.21.
//  Copyright © 2021 Alexander Ehrlich. All rights reserved.
//

import UIKit

class ProductRequestViewController: UIViewController {
    
    @IBOutlet weak var userInputTextField: UITextField!
    
    
    @IBOutlet weak var sendButtonOutlet: UIButton!
    
    var httpManager = HttpRequestManager()
    
    let activityView = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        httpManager.delegate = self
        
        sendButtonOutlet.layer.cornerRadius = 10
        
    }
    
    @IBAction func sendRequestButtonPressed(_ sender: UIButton) {
        

        if userInputTextField.text == ""{
        
        let alert = UIAlertController(title: "Moment", message: "Du musst etwas eingeben, damit du es absenden kannst.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }else {
            //Send Data to Data Base - fehlt noch
            
            activityView.center = self.view.center
            activityView.startAnimating()
            self.view.addSubview(activityView)
            
            
            let productString = "\(userInputTextField.text!)".replacingOccurrences(of: " ", with: "")
            
            httpManager.postProductRequest(for: productString)

        }
    }
}

extension ProductRequestViewController: HttpRequestManagerDelegate{
    
    func didFinishWithRequest(result: Bool) {
      
        DispatchQueue.main.async {
            if result == false{
                
                self.activityView.stopAnimating()
                
                let alertController = UIAlertController(title: "Oops", message: "Etwas ist schief gegangen. Versuche es später erneut", preferredStyle: .alert)
                
                let alertAction = UIAlertAction(title: "Okay", style: .default) { (action) in
                    self.navigationController?.popViewController(animated: true)
                }
                
                alertController.addAction(alertAction)
                
                self.present(alertController, animated: true, completion: nil)
            }else{
                
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
