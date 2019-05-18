//
//  LobbyViewController.swift
//  Slothies
//
//  Created by Lucas Miranda Lin on 13/05/19.
//  Copyright © 2019 Slothies Inc. All rights reserved.
//

import UIKit

class LobbyViewController: UIViewController {

    @IBOutlet weak var ConfirmButton: UIButton!
    @IBOutlet weak var RoomCodeField: UITextField!
    @IBOutlet weak var PasswordField: UITextField!
    var roomCode:String? = nil
    
    //hardcoded room
    //let tempRoom = RoomGroup(name: "room", pass: "pass")
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ConfirmButton.layer.cornerRadius = 10
        ConfirmButton.layer.masksToBounds = true
        //rooms.append(tempRoom)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func ConfirmRoomButton(_ sender: Any) {
        if let roomCode = self.RoomCodeField.text as? String {
            if let password = self.PasswordField.text as? String {
                if let currentRoom = NetworkHandler.singleton.fetchRoom(code: roomCode, pass: password) {
                    self.roomCode = roomCode
                    performSegue(withIdentifier: "ToSelectionScreen", sender: nil)
                }
            }
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let selectionScreen = segue.destination as? SelectionViewController {
            selectionScreen.roomCode = self.roomCode
        }
    }
 

}
