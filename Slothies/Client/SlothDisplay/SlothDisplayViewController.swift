//
//  SlothDisplayViewController.swift
//  Slothies
//
//  Created by Lucas Miranda Lin on 13/05/19.
//  Copyright © 2019 Slothies Inc. All rights reserved.
//

import UIKit

class SlothDisplayViewController: UIViewController {

    @IBOutlet weak var viewBlur: UIView!
    
    @IBOutlet weak var SlothyNameLabel: UILabel!
    
    @IBOutlet weak var statusView: UIView!
    
    @IBOutlet weak var statusBlur: UIView!
    
    @IBOutlet weak var HungerProgressBar: UIProgressView!
    
    @IBOutlet weak var SleepProgressBar: UIProgressView!
    
    @IBOutlet weak var SlothometerProgressBar: UIProgressView!
    
    @IBOutlet weak var SlothyBubble: UIImageView!
    
    @IBOutlet weak var SlothyBubbleLabel: UILabel!
    
    @IBOutlet weak var AppleButton: UIButton!
    
    @IBOutlet weak var SleepButton: UIButton!
    
    @IBOutlet weak var SlothyButton: UIButton!
    
    @IBOutlet weak var SlothySprite: UIImageView!
    
    var room: RoomGroup?
    var player: Player?//current player - use to check for feeding/sleeping permissions
    var slothy: Sloth?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showSlothyStatus()
        if let sloth = self.slothy as Sloth? {
            renderSlothy(slothy: sloth)
        }
        
        SlothyButton.isHidden = true
        AppleButton.isEnabled = false
        SleepButton.isEnabled = false
        navigationController!.setNavigationBarHidden(false, animated: true)
        slothyInformationSetup()
        permissionSetup()
    }
    
    func permissionSetup () {
        if let player = player {
            if let slothy = slothy {
                let playerNameConfirmed = player == slothy.player!
                let slothyNameConfirmed = slothy.name.elementsEqual(player.slothy!.name)
                if playerNameConfirmed && slothyNameConfirmed {
                    showSpeech()
                    showAndEnableButtons()
                }
            }
        }
    }
    
    func showSpeech() {
        SlothyBubble.isHidden = false
        SlothyBubbleLabel.isHidden = false
    }
    
    func showSlothyStatus() {
        viewBlur.backgroundColor = .clear
        let viewBlurEffect = UIBlurEffect(style: .dark)
        let viewBlurEffectView = UIVisualEffectView(effect: viewBlurEffect)
        viewBlurEffectView.frame = self.view.bounds
        viewBlurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewBlur.addSubview(viewBlurEffectView)
        
        statusView.layer.cornerRadius = 10
        statusView.layer.masksToBounds = true
        HungerProgressBar.layer.cornerRadius = 10
        HungerProgressBar.layer.masksToBounds = true
        HungerProgressBar.transform = HungerProgressBar.transform.scaledBy(x: 1, y: 4)
        SleepProgressBar.layer.cornerRadius = 10
        SleepProgressBar.layer.masksToBounds = true
        SleepProgressBar.transform = SleepProgressBar.transform.scaledBy(x: 1, y: 4)
        SlothometerProgressBar.layer.cornerRadius = 10
        SlothometerProgressBar.layer.masksToBounds = true
        SlothometerProgressBar.transform = SlothometerProgressBar.transform.scaledBy(x: 1, y: 4)
        statusView.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0)
        statusBlur.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        statusBlur.addSubview(blurEffectView)
    }
    
    private var buttonsWorking = false
    
    func showAndEnableButtons () {
        buttonsWorking = true
        SlothyButton.isHidden = false
        AppleButton.isEnabled = true
        SleepButton.isEnabled = true
    }
    
    func slothyInformationSetup () {
        if let slothy = slothy {
            SlothyNameLabel.text = slothy.name
            updateBars(anime: false)
        }
    }
    
    func updateBars (anime: Bool) {
        HungerProgressBar.setProgress(Float(slothy!.hunger / Sloth.statusMaxValue), animated: anime)
        if (HungerProgressBar.progress >= 0.7) {
            HungerProgressBar.progressTintColor = .green
        } else if HungerProgressBar.progress >= 0.3 {
            HungerProgressBar.progressTintColor = .yellow
        } else {
            HungerProgressBar.progressTintColor = .red
        }
        
        SleepProgressBar.setProgress(Float(slothy!.sleep / Sloth.statusMaxValue), animated: anime)
        if (SleepProgressBar.progress >= 0.7) {
            SleepProgressBar.progressTintColor = .green
        } else if SleepProgressBar.progress >= 0.3 {
            SleepProgressBar.progressTintColor = .yellow
        } else {
            SleepProgressBar.progressTintColor = .red
        }
        
        SlothometerProgressBar.setProgress(Float(slothy!.sloth / Slothometer.maxValue), animated: anime)
        if (SlothometerProgressBar.progress >= 0.7) {
            SlothometerProgressBar.progressTintColor = .green
        } else if SlothometerProgressBar.progress >= 0.3 {
            SlothometerProgressBar.progressTintColor = .yellow
        } else {
            SlothometerProgressBar.progressTintColor = .red
        }
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
            slothSprite = UIImage(named: "Female Slothy Idle")!
        }
        SlothySprite.image = slothSprite
        SlothyButton.setImage(slothSprite, for: .normal)
    }
    
    @IBAction func SlothyButton(_ sender: Any) {
        if AppleButton.isHidden && buttonsWorking {
            AppleButton.isHidden = false
            SleepButton.isHidden = false
        } else {
            AppleButton.isHidden = true
            SleepButton.isHidden = true
            slothyIdleInterface()
        }
    }
    
    func slothyEatsInterface() {
        var slothSprite: UIImage
        
        if(slothy!.sex == .male) {
            slothSprite = UIImage(named: "Male Slothy Eating")!
        } else {
            slothSprite = UIImage(named: "Female Slothy Eating")!
        }
        SlothySprite.image = slothSprite
        SlothyButton.setImage(slothSprite, for: .normal)
        SlothyBubble.isHidden = false
        SlothyBubbleLabel.isHidden = false
        SlothyBubbleLabel.text = "Nhammm"
    }
    
    func slothySleepsInterface() {
        var slothSprite: UIImage
        
        if(slothy!.sex == .male) {
            slothSprite = UIImage(named: "Male Slothy Sleeping")!
        } else {
            slothSprite = UIImage(named: "Female Slothy Sleeping")!
        }
        SlothySprite.image = slothSprite
        SlothyButton.setImage(slothSprite, for: .normal)
        SlothyBubble.isHidden = true
        SlothyBubbleLabel.isHidden = true
    }
    
    func slothyIdleInterface() {
        var slothSprite: UIImage
        
        if(slothy!.sex == .male) {
            slothSprite = UIImage(named: "Male Slothy Idle")!
        } else {
            slothSprite = UIImage(named: "Female Slothy Idle")!
        }
        SlothySprite.image = slothSprite
        SlothyButton.setImage(slothSprite, for: .normal)
        SlothyBubble.isHidden = false
        SlothyBubbleLabel.isHidden = false
        SlothyBubbleLabel.text = "Click Me"
    }
    
    @IBAction func feedButtonPressed(_ sender: Any) {
        if let (netRoom, netSlothy) = NetworkHandler.singleton.requestFeedSloth(room: room!, slothy: slothy!) {
            room!.copyFrom(room: netRoom)
            slothy = netSlothy
            updateBars(anime: true)
            slothyEatsInterface()
            
            //TODO: idle
        }
    }
    
    @IBAction func sleepButtonPressed(_ sender: Any) {
        if let (netRoom, netSlothy) = NetworkHandler.singleton.requestSleepSloth(room: room!, slothy: slothy!) {
            room!.copyFrom(room: netRoom)
            slothy = netSlothy
            updateBars(anime: true)
            slothySleepsInterface()
            
            //TODO: idle
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
