//
//  SlothCreationViewController.swift
//  Slothies
//
//  Created by Lucas Miranda Lin on 13/05/19.
//  Copyright © 2019 Slothies Inc. All rights reserved.
//

import UIKit

class SlothCreationViewController: UIViewController, UITextFieldDelegate {
    
    var player: Player? = nil
    var room: RoomGroup? = nil
    var index: Int? = nil
    var sex: Sex? = nil
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @IBOutlet weak var CreateSlothyButton: UIButton!
    
    @IBOutlet weak var SlothyNameField: UITextField!
    
    @IBOutlet weak var SlothySprite: UIImageView!
    
    @IBAction func MaleSlothyButton(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.SlothySprite.image = UIImage(named: "Male Slothy Idle")
        }
        sex = .male
    }
    
    @IBAction func FemaleSlothyButton(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.SlothySprite.image = UIImage(named: "Female Slothy Idle")
        }
        sex = .female
    }
    
    
    @IBAction func CreateSlothyButton(_ sender: UIButton) {
        if let slothyName = SlothyNameField.text as String? {
            if let slothySex = self.sex as Sex? {
                NetworkHandler.singleton.requestCreateSlothAndLinkPlayer(room: room!, player: player!, name: slothyName, sex: slothySex, index: index!) { (result: (room: RoomGroup, player: Player)?, err) in
                    if let err = err {
                        print(err)
                    } else {
                        self.room = result!.room
                        self.player = result!.player
                        DispatchQueue.main.async{
                            
                            self.performSegue(withIdentifier: "ToGameScreen", sender: self)
                        }
                    }
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SlothyNameField.delegate = self
        DispatchQueue.main.async {
            self.CreateSlothyButton.layer.cornerRadius = 10
            self.CreateSlothyButton.layer.masksToBounds = true
        }
    }
    
    func receiveData (player: Player, group: RoomGroup, index: Int) {
        self.player = player
        self.room = group
        self.index = index
    }
    
    @IBAction func helpButtonPressed(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "ToTutorialScreen", sender: self)
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let game = segue.destination as? GameViewController {
            game.receiveData(room: room!, player: player!)
        }
    }

}
