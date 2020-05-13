//
//  KategorieViewController.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 16.03.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit

class KategorieViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

                let testImage = UIImage(named: "Eier_aus Freilandhaltung_38_1,59")
               let testImageView = UIImageView(image: testImage)
               testImageView.frame = CGRect(origin: CGPoint(x: 200, y: 700), size: CGSize(width: 20, height: 20))
               self.view.addSubview(testImageView)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
