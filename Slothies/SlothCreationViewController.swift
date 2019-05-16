//
//  SlothCreationViewController.swift
//  Slothies
//
//  Created by Lucas Miranda Lin on 13/05/19.
//  Copyright © 2019 Slothies Inc. All rights reserved.
//

import UIKit

class SlothCreationViewController: UIViewController {

    @IBOutlet weak var EnterSlothyNameField: UITextField!
    
    @IBOutlet weak var CreateSlothyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        EnterSlothyNameField.layer.cornerRadius = 10
        EnterSlothyNameField.layer.masksToBounds = true
        CreateSlothyButton.layer.cornerRadius = 10
        EnterSlothyNameField.layer.masksToBounds = true
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
