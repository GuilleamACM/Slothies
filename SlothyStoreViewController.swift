//
//  SlothyStoreViewController.swift
//  Slothies
//
//  Created by Guilherme Augusto Campos de Melo on 28/05/19.
//  Copyright © 2019 Slothies Inc. All rights reserved.
//

import UIKit

class SlothyStoreViewController: UIViewController, GameDataUpdateable {
    
    func completionUpdateInterface(room: RoomGroup?, err: String?) {
        if let room = room {
            self.room = room
        }
    }
    
    
    @IBOutlet weak var debugButton: UIButton!
    @IBOutlet weak var debug0: UIButton!
    @IBOutlet weak var debug1: UIButton!
    @IBOutlet weak var debug2: UIButton!
    @IBOutlet weak var debug3: UIButton!
    var debugClicked = false
    var room:RoomGroup?
    var player:Player?
    
    @IBAction func DebugButtonsReveal(_ sender: UIButton) {
        
        if(!debugClicked){
            debug0.isHidden = false
            debug1.isHidden = false
            debug2.isHidden = false
            debug3.isHidden = false
            debugClicked = true
        }
        else{
            debug0.isHidden = true
            debug1.isHidden = true
            debug2.isHidden = true
            debug3.isHidden = true
            debugClicked = false
        }
    }
    
    @IBAction func DebugWipeRoom(_ sender: UIButton) {
        print("Debugging wipe room")
        NetworkHandler.singleton.wipeRoom(room: room!) { (room:RoomGroup?,err: String?) in }
        
        
    }
    @IBAction func DebugJumpDate(_ sender: UIButton) {
        print("Debugging jump date")
        NetworkHandler.singleton.jumpToPastDate(room: room!, timeInterval: 14400) { (room:RoomGroup?, err: String?) in
            if let err = err{
                print(err)
            }else if let _ = room{
                print("sucess jump date")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkHandler.singleton.listenerDispatch = self
        debug0.layer.cornerRadius = 5
        debug1.layer.cornerRadius = 5
        debug2.layer.cornerRadius = 5
        debug3.layer.cornerRadius = 5
    }
    
    func receiveData(room: RoomGroup, player: Player) {
        self.room = room
        self.player = player
    }
}
