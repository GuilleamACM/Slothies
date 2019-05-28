//
//  SlothyStoreViewController.swift
//  Slothies
//
//  Created by Guilherme Augusto Campos de Melo on 28/05/19.
//  Copyright © 2019 Slothies Inc. All rights reserved.
//

import UIKit

class SlothyStoreViewController: UIViewController {
    
    @IBOutlet weak var viewBlur: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBlur.backgroundColor = .clear
        let viewBlurEffect = UIBlurEffect(style: .dark)
        let viewBlurEffectView = UIVisualEffectView(effect: viewBlurEffect)
        viewBlurEffectView.frame = self.view.bounds
        viewBlurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewBlur.addSubview(viewBlurEffectView)
    }
    
    @IBAction func storeButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "ToTutorial", sender: self)
    }
}
