//
//  AlreadySelectedViewController.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 24.01.21.
//  Copyright © 2021 Alexander Ehrlich. All rights reserved.
//

import UIKit

protocol AlreradySelectedViewControllerDelegate{
    
    //Bool: true --> okay, false --> deleted
    func passUserSelectionFromAlreaySelectedVC(selection: Bool, sender: AlreadySelectedViewController)
}

class AlreadySelectedViewController: UIViewController {
    
    var delegate : AlreradySelectedViewControllerDelegate?

    @IBOutlet weak var backButtonOutlet: UIButton!
    @IBOutlet weak var deleteButtonOutlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButtonOutlet.layer.cornerRadius = 8
        deleteButtonOutlet.layer.cornerRadius = 8

    }

    @IBAction func AcceptButtonPressed(_ sender: UIButton) {
        delegate?.passUserSelectionFromAlreaySelectedVC(selection: true, sender: self)
    }
    
    
    
    @IBAction func deleteProductButtonPressed(_ sender: UIButton) {
        delegate?.passUserSelectionFromAlreaySelectedVC(selection: false, sender: self)
    }
}
