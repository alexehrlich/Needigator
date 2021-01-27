//
//  ProducNotAvailableViewController.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 25.01.21.
//  Copyright © 2021 Alexander Ehrlich. All rights reserved.
//

import UIKit

protocol ProducNotAvailableViewControllerDelegate{
    func hasToPerformSegue()
}

class ProducNotAvailableViewController: UIViewController {

    @IBOutlet weak var promptHeading: UILabel!
    @IBOutlet weak var userPromptLabel: UILabel!
    @IBOutlet weak var promptButton: UIButton!
    
    var delegate: ProducNotAvailableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layer.cornerRadius = 10
    }
    
    
    @IBAction func goToEnterViewController(_ sender: UIButton) {
        delegate?.hasToPerformSegue()
    }
}
