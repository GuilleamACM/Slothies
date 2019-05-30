//
//  SelectionViewController.swift
//  Slothies
//
//  Created by Lucas Miranda Lin on 13/05/19.
//  Copyright © 2019 Slothies Inc. All rights reserved.
//

import UIKit

class SelectionViewController: UIViewController {

    var room: RoomGroup? = nil
    var player: Player? = nil
    var slotPressed: Int? = nil

    @IBOutlet var SlotsButton: [UIButton]!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRoom(room: room!)
        // Do any additional setup after loading the view.
    }
    
    func loadRoom(room: RoomGroup) {
        DispatchQueue.main.async {
            for (index, player) in room.players.enumerated() {
                if let _ = player {
                    let image: UIImage
                    if(room.getSlothy(index: index)!.sex == .male) {
                        image = UIImage(named: "Male Slothy Face Idle")!
                    } else {
                        image = UIImage(named: "Female Slothy Face Idle")!
                    }
                    self.SlotsButton[index].setBackgroundImage(nil, for: .normal)
                    self.SlotsButton[index].setImage(image, for: .normal)
                    self.SlotsButton[index].setBackgroundImage(nil, for: .disabled)
                    self.SlotsButton[index].setImage(image, for: .disabled)
                    self.SlotsButton[index].isEnabled = false
                    self.SlotsButton[index].alpha = 1
                }
            }
        }
    }
    
    @IBAction func Slot1Pressed(_ sender: Any) {
        slotPressed = 0
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "ToSlothCreationScreen", sender: self)
        }
    }
    
    @IBAction func Slot2Pressed(_ sender: Any) {
        slotPressed = 1
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "ToSlothCreationScreen", sender: self)
        }

    }
    
    @IBAction func Slot3Pressed(_ sender: Any) {
        slotPressed = 2
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "ToSlothCreationScreen", sender: self)
        }

    }
    
    @IBAction func Slot4Pressed(_ sender: Any) {
        slotPressed = 3
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "ToSlothCreationScreen", sender: self)
        }
    }
    
    func receiveData(room: RoomGroup, player:Player) {
        self.room = room
        self.player = player
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let SlothCreationScreen = segue.destination as? SlothCreationViewController {
            SlothCreationScreen.receiveData(player: player!, group: room!, index: slotPressed!)
        }
    }
    

}
