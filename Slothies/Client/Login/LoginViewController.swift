//
//  LoginViewController.swift
//  Slothies
//
//  Created by Lucas Miranda Lin on 14/05/19.
//  Copyright © 2019 Slothies Inc. All rights reserved.
//

import UIKit

import Firebase
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate, UITextFieldDelegate  {

    @IBOutlet weak var EnterUsernameField: UITextField!
    
    @IBOutlet weak var EnterPasswordField: UITextField!
    
    @IBOutlet weak var LoginButton: UIButton!
    
    var room:RoomGroup? = nil
    var user: String? = nil
    var player:Player? = nil
    var hasSigned = false
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        EnterUsernameField.delegate = self
        EnterPasswordField.delegate = self
        DispatchQueue.main.async {
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.view.backgroundColor = .clear
            
            self.LoginButton.layer.cornerRadius = 10
            self.LoginButton.layer.masksToBounds = true
            
            // TODO(developer) Configure the sign-in button look/feel
        }
    }
    
    @IBAction func loginButton(_ sender: Any) {
        /* CODE INVALIDATED BY SWITCH TO GOOGLE AUTH
        if let username = self.EnterUsernameField.text {
            if let password = self.EnterPasswordField.text {
                print("\(username):\(password)")
                if let currentPlayer = NetworkHandler.singleton.fetchPlayer(credential: username, pass: password) {
                    player = currentPlayer
                    performSegue(withIdentifier: "ToLobbyScreen", sender: nil)
                }
                
            }
        }
        */
    }
    
    func signIn (user: String) {
        if !hasSigned {
            hasSigned = true
            NetworkHandler.singleton.fetchRoom(forUser: user) { (room, err) in
                if let room = room {
                    self.user = user
                    self.room = room
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "ToGameScreen", sender: self)
                    }
                } else {
                    if err! == "new player" {
                        self.player = Player(user: user)
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "ToLobbyScreen", sender: self)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier! == "ToLobbyScreen" {
            if let dest = segue.destination as? LobbyViewController {
                dest.receiveData(player: player!)
            }
        } else {
            if let dest = segue.destination as? GameViewController {
                dest.receiveData(room: room!, player: room!.getPlayer(withUser: user!)!)
            }
        }
    }
    
}
