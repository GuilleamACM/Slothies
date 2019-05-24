//
//  LoginViewController.swift
//  Slothies
//
//  Created by Lucas Miranda Lin on 14/05/19.
//  Copyright © 2019 Slothies Inc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var EnterUsernameField: UITextField!
    
    @IBOutlet weak var EnterPasswordField: UITextField!
    
    @IBOutlet weak var LoginButton: UIButton!
    
    var player:Player? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        LoginButton.layer.cornerRadius = 10
        LoginButton.layer.masksToBounds = true
        
        //hardcoded admin account
        //let admin = Player(username: "admin" , pass: "admin123")
        //accounts.append(admin)

        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func loginButton(_ sender: Any) {
        if let username = self.EnterUsernameField.text {
            if let password = self.EnterPasswordField.text {
                print("\(username):\(password)")
                if let currentPlayer = NetworkHandler.singleton.fetchPlayer(username: username, pass: password) {
                    player = currentPlayer
                    performSegue(withIdentifier: "ToLobbyScreen", sender: nil)
                }
                
            }
        }
        
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let dest = segue.destination as? LobbyViewController {
            dest.receiveData(player: player!)
        }
    }
    
}
