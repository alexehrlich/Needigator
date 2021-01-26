//
//  ProductRequestViewController.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 25.01.21.
//  Copyright © 2021 Alexander Ehrlich. All rights reserved.
//

import UIKit

class ProductRequestViewController: UIViewController {
    
    @IBOutlet weak var productBrandTextField: UITextField!
    @IBOutlet weak var productTypeTextField: UITextField!
    @IBOutlet weak var userMailTestField: UITextField!
    
    
    @IBOutlet weak var sendButtonOutlet: UIButton!
    
    let httpManager = HttpRequestManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendButtonOutlet.layer.cornerRadius = 10
        
    }
    
    @IBAction func sendRequestButtonPressed(_ sender: UIButton) {
        
      
        
        if productTypeTextField.text == "" || productBrandTextField.text == ""{
        
        let alert = UIAlertController(title: "Moment", message: "Du musst Angaben zur Produktmarke und zur Produktbezeichnung machen, bevor du die Anfrage absenden kannst.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }else {
            //Send Data to Data Base - fehlt noch
            
            let productString = "\(productBrandTextField.text!)\(productTypeTextField.text!)".replacingOccurrences(of: " ", with: "")
            
            httpManager.postProductRequest(for: productString)
            navigationController?.popViewController(animated: true)
        }
    }
}
