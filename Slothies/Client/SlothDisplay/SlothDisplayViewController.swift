//
//  SlothDisplayViewController.swift
//  Slothies
//
//  Created by Lucas Miranda Lin on 13/05/19.
//  Copyright © 2019 Slothies Inc. All rights reserved.
//

import UIKit

class SlothDisplayViewController: UIViewController {

    @IBOutlet weak var SlothyNameLabel: UILabel!
    
    @IBOutlet weak var StatusContainerView: UIView!
    
    @IBOutlet weak var HungerProgressBar: UIProgressView!
    
    @IBOutlet weak var SleepProgressBar: UIProgressView!
    
    @IBOutlet weak var SlothometerProgressBar: UIProgressView!
    
    @IBOutlet weak var SlothyBubbleLabel: UILabel!
    
    @IBOutlet weak var EatButton: UIButton!
    
    @IBOutlet weak var SleepButton: UIButton!
    
    @IBOutlet weak var SlothySprite: UIButton!
    
    @IBAction func SlothyButton(_ sender: Any) {
        
    }
    
    var room: RoomGroup?
    var player: Player?//current player - use to check for feeding/sleeping permissions
    var slothy: Sloth?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StatusContainerView.layer.cornerRadius = 10
        StatusContainerView.layer.masksToBounds = true
        
        if let sloth = self.slothy as Sloth? {
            renderSlothy(slothy: sloth)
        }
        
        navigationController!.setNavigationBarHidden(false, animated: true)
        slothyInformationSetup()
        permissionSetup()
    }
    
    func permissionSetup () {
        if let player = player {
            if let slothy = slothy {
                let playerNameConfirmed = player.identifier.elementsEqual(slothy.player!.identifier)
                let slothyNameConfirmed = slothy.name.elementsEqual(player.slothy!.name)
                if !(playerNameConfirmed && slothyNameConfirmed) {
                    hideSpeechAndButtons()
                }
            }
        }
    }
    
    func hideSpeechAndButtons() {
        //TODO 
    }
    
    func slothyInformationSetup () {
        if let slothy = slothy {
            SlothyNameLabel.text = slothy.name
            updateBars(anime: false)
        }
    }
    
    func updateBars (anime: Bool) {
        HungerProgressBar.setProgress(Float(slothy!.hunger / Sloth.statusMaxValue), animated: anime)
        SleepProgressBar.setProgress(Float(slothy!.sleep / Sloth.statusMaxValue), animated: anime)
        SlothometerProgressBar.setProgress(Float(slothy!.sloth / Slothometer.maxValue), animated: anime)
    }
    
    func receiveData(room: RoomGroup, slothy: Sloth, player: Player) {
        self.room = room
        self.slothy = slothy
        self.player = player
    }
    
    func renderSlothy(slothy: Sloth){
        var slothSprite: UIImage
        
        if(slothy.sex == .male) {
            slothSprite = UIImage(named: "Male Slothy Idle")!
        } else {
            slothSprite = UIImage(named: "Slothy Eating")!
        }
        
        SlothySprite.setImage(slothSprite, for: .normal)
    }
    
    func slothyEatsInterface() {
    
    }
    
    func slothySleepsInterface() {
        
    }
    
    func slothyIdleInterface() {
        
    }
    
    @IBAction func feedButtonPressed(_ sender: Any) {
        slothyEatsInterface()
    }
    
    @IBAction func sleepButtonPressed(_ sender: Any) {
        slothySleepsInterface()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
