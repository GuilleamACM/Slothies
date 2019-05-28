//
//  ViewController.swift
//  Slothies
//
//  Created by Lucas Miranda Lin on 13/05/19.
//  Copyright © 2019 Slothies Inc. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {

    
    private func authorizeHealthKit() {
        
        HealthKitSetupAssistant.authorizeHealthKit { (authorized, error) in
            
            guard authorized else {
                
                let baseMessage = "HealthKit Authorization Failed"
                
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseMessage)
                }
                
                return
            }
            
            print("HealthKit Successfully Authorized.")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorizeHealthKit()// authorization for the halthKit when the app is openned

    }

    @IBAction func toLoginScreen(_ sender: Any) {
        self.performSegue(withIdentifier: "ToLoginScreen", sender: self)
    }
    
    @IBAction func tutorialButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "ToTutorial", sender: self)
    }
    
}

