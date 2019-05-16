//
//  LoginViewController.swift
//  Slothies
//
//  Created by Lucas Miranda Lin on 14/05/19.
//  Copyright © 2019 Slothies Inc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var LoginPanelView: UIView!

    @IBOutlet weak var EnterUsernameField: UITextField!
    
    @IBOutlet weak var EnterPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoginPanelView.layer.cornerRadius = 10
        LoginPanelView.layer.masksToBounds = true
        EnterUsernameField.layer.cornerRadius = 10
        EnterUsernameField.layer.masksToBounds = true
        EnterPasswordField.layer.cornerRadius = 10
        EnterPasswordField.layer.masksToBounds = true
        // Do any additional setup after loading the view.
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
