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
    var roomPass:String? = nil
    var room:RoomGroup? = nil
    var player:Player? = nil
    
    //hardcoded room
    //let tempRoom = RoomGroup(name: "room", pass: "pass")
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.ConfirmButton.layer.cornerRadius = 10
            self.ConfirmButton.layer.masksToBounds = true
        }
        //rooms.append(tempRoom)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func ConfirmRoomButton(_ sender: Any) {
        if let roomCode = self.RoomCodeField.text {
            if let password = self.PasswordField.text {
                NetworkHandler.singleton.fetchRoom(code: roomCode, pass: password) { (room, errStr) in
                    if let room = room {
                        self.room = room
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "ToSelectionScreen", sender: self)
                        }
                    } else {
                        print(errStr!)
                    }
                }
            }
        }
    }
    
    func receiveData(player:Player) {
        self.player = player
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let selectionScreen = segue.destination as? SelectionViewController {
            selectionScreen.receiveData(room: room!, player: player!)
        }
    }
 

}
