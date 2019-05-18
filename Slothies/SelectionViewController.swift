//
//  SelectionViewController.swift
//  Slothies
//
//  Created by Lucas Miranda Lin on 13/05/19.
//  Copyright © 2019 Slothies Inc. All rights reserved.
//

import UIKit

class SelectionViewController: UIViewController {

    var roomCode: String? = nil
    var roomPass: String? = nil
    var slotPressed: Int? = nil

    @IBOutlet var SlotsButton: [UIButton]!
    override func viewDidLoad() {
        super.viewDidLoad()
        let room = NetworkHandler.singleton.fetchRoom(code: roomCode!, pass: roomPass!)
        loadRoom(room: room!)

        
        // Do any additional setup after loading the view.
    }
    
    func loadRoom(room: RoomGroup) {
        
        for (index, players) in room.players.enumerated() {
            let image = UIImage(named: "Slothy\(index+1) Face")
            SlotsButton[index].setBackgroundImage(nil, for: .normal)
            SlotsButton[index].setImage(image, for: .normal)
            SlotsButton[index].isEnabled = false
        }
    }
    
    @IBAction func Slot1Pressed(_ sender: Any) {
        slotPressed = 1
        performSegue(withIdentifier: "ToSlothCreationScreen", sender: nil)
    }
    
    @IBAction func Slot2Pressed(_ sender: Any) {
        slotPressed = 2
        performSegue(withIdentifier: "ToSlothCreationScreen", sender: nil)

    }
    
    @IBAction func Slot3Pressed(_ sender: Any) {
        slotPressed = 3
        performSegue(withIdentifier: "ToSlothCreationScreen", sender: nil)

    }
    
    @IBAction func Slot4Pressed(_ sender: Any) {
        slotPressed = 4
        performSegue(withIdentifier: "ToSlothCreationScreen", sender: nil)

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let SlothCreationScreen = segue.destination as? SlothCreationViewController {
            SlothCreationScreen.receiveData()
        }
    }
    */

}
