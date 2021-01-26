//
//  ProducNotAvailableViewController.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 25.01.21.
//  Copyright © 2021 Alexander Ehrlich. All rights reserved.
//

import UIKit

protocol ProducNotAvailableViewControllerDelegate{
    func hasToPErformSegue()
}

class ProducNotAvailableViewController: UIViewController {

    @IBOutlet weak var UserPromptLabel: UILabel!
    
    var delegate: ProducNotAvailableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layer.cornerRadius = 10
    }
    
    
    @IBAction func goToEnterViewController(_ sender: UIButton) {
        delegate?.hasToPErformSegue()
    }
}
