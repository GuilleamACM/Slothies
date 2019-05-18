//
//  ViewController.swift
//  Slothies
//
//  Created by Lucas Miranda Lin on 13/05/19.
//  Copyright © 2019 Slothies Inc. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }

    @IBAction func toLoginScreen(_ sender: Any) {
        self.performSegue(withIdentifier: "ToLoginScreen", sender: self)
    }
    
}

