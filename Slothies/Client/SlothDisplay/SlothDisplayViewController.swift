//
//  SlothDisplayViewController.swift
//  Slothies
//
//  Created by Lucas Miranda Lin on 13/05/19.
//  Copyright © 2019 Slothies Inc. All rights reserved.
//

import UIKit

class SlothDisplayViewController: UIViewController, GameDataUpdateable {
    func completionUpdateInterface(room: RoomGroup?, err: String?) {
        if let room = room {
            self.room!.copyFrom(room: room)
            self.slothy = self.room!.getSlothy(withName: slothy!.name)
            self.player = self.room!.getPlayer(withUser: player!.user)
            self.updateBars(anime: true)
            switch slothy!.state {
            case .eating:
                slothyEatsInterface()
                break
            case .sleeping:
                slothySleepsInterface()
                break
            case .dead:
                slothyDiesInterface()
                break
            default:
                slothyIdleInterface()
                break
            }
        } else {
            print(err!)
        }
    }

    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        slothy = room!.getSlothy(withName: slothy!.name)
        NetworkHandler.listenerDispatch = self
        DispatchQueue.main.async {
            self.SlothyBubble.isHidden = true
            self.SlothyBubbleLabel.isHidden = true
            switch self.slothy!.state {
            case .eating:
                self.slothyEatsInterface()
                break
            case .sleeping:
                self.slothySleepsInterface()
                break
            case .dead:
                self.slothyDiesInterface()
                break
            default:
                self.slothyIdleInterface()
                break
            }
            self.updateBars(anime: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkHandler.listenerDispatch = self
        
        //FF749C
        self.navigationController?.navigationBar.tintColor = UIColor(red:1.00, green:0.45, blue:0.61, alpha:1.0)
        
        DispatchQueue.main.async {
            self.showSlothyStatus()
            if let sloth = self.slothy as Sloth? {
                self.renderSlothy(slothy: sloth)
            }
            self.SlothyButton.isHidden = true
            self.AppleButton.isEnabled = false
            self.SleepButton.isEnabled = false
            self.SlothyBubble.isHidden = true
            self.SlothyBubble.isHidden = true
            self.navigationController!.setNavigationBarHidden(false, animated: true)
            self.slothyInformationSetup()
            self.permissionSetup()
        }
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
    
    func showSpeechInner() {
        SlothyBubble.isHidden = false
        SlothyBubbleLabel.isHidden = false
    }
    
    func showSpeech() {
        if Thread.isMainThread {
            showSpeechInner()
        } else {
            DispatchQueue.main.async {
                self.showSpeechInner()
            }
        }
    }
    
    func showSlothyStatusInner() {
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
    
    func showSlothyStatus() {
        if Thread.isMainThread {
            showSlothyStatusInner()
        } else {
            DispatchQueue.main.async {
                self.showSlothyStatusInner()
            }
        }
    }
    
    private var buttonsWorking = false
    
    func showAndEnableButtonsInner () {
        buttonsWorking = true
        SlothyButton.isHidden = false
        AppleButton.isEnabled = true
        SleepButton.isEnabled = true
    }
    
    func showAndEnableButtons() {
        if Thread.isMainThread {
            showAndEnableButtonsInner()
        } else {
            DispatchQueue.main.async {
                self.showAndEnableButtonsInner()
            }
        }
    }
    
    func slothyInformationSetupInner () {
        if let slothy = slothy {
            SlothyNameLabel.text = slothy.name
            updateBars(anime: false)
        }
    }
    
    func slothyInformationSetup() {
        if Thread.isMainThread {
            slothyInformationSetupInner()
        } else {
            DispatchQueue.main.async {
                self.slothyInformationSetupInner()
            }
        }
    }
    
    func updateBarsInner (anime: Bool) {
        HungerProgressBar.setProgress(Float(slothy!.hunger / Sloth.hungerMaxValue), animated: anime)
        if (HungerProgressBar.progress >= 0.7) {
            HungerProgressBar.progressTintColor = .green
        } else if HungerProgressBar.progress >= 0.3 {
            HungerProgressBar.progressTintColor = .yellow
        } else {
            HungerProgressBar.progressTintColor = .red
        }
        
        SleepProgressBar.setProgress(Float(slothy!.sleep / Sloth.sleepMaxValue), animated: anime)
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
    
    func updateBars(anime: Bool) {
        if Thread.isMainThread {
            updateBarsInner(anime: anime)
        } else {
            DispatchQueue.main.async {
                self.updateBarsInner(anime: anime)
            }
        }
    }
    
    func receiveData(room: RoomGroup, slothy: Sloth, player: Player) {
        self.room = room
        self.slothy = slothy
        self.player = player
    }
    
    func renderSlothyInner(slothy: Sloth){
        var slothSprite: UIImage
        
        if(slothy.sex == .male) {
            slothSprite = UIImage(named: "Male Slothy Idle")!
        } else {
            slothSprite = UIImage(named: "Female Slothy Idle")!
        }
        SlothySprite.image = slothSprite
        SlothyButton.setImage(slothSprite, for: .normal)
    }
    
    func renderSlothy(slothy: Sloth) {
        if Thread.isMainThread {
            renderSlothyInner(slothy: slothy)
        } else {
            DispatchQueue.main.async {
                self.renderSlothyInner(slothy: slothy)
            }
        }
    }
    
    func SlothyButtonInner(_ sender: Any) {
        SlothyBubble.isHidden = true
        SlothyBubbleLabel.isHidden = true
        if AppleButton.isHidden && buttonsWorking {
            AppleButton.isHidden = false
            SleepButton.isHidden = false
        } else {
            AppleButton.isHidden = true
            SleepButton.isHidden = true
        }
    }
    
    @IBAction func SlothyButton(_ sender: Any) {
        if Thread.isMainThread {
            SlothyButtonInner(sender)
        } else {
            DispatchQueue.main.async {
                self.SlothyButtonInner(sender)
            }
        }
    }
    
    func slothyEatsInterfaceInner() {
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
    
    func slothyEatsInterface() {
        if Thread.isMainThread {
            slothyEatsInterfaceInner()
        } else {
            DispatchQueue.main.async {
                self.slothyEatsInterfaceInner()
            }
        }
    }
    
    func slothySleepsInterfaceInner() {
        var slothSprite: UIImage
        
        if(slothy!.sex == .male) {
            slothSprite = UIImage(named: "Male Slothy Sleeping")!
        } else {
            slothSprite = UIImage(named: "Female Slothy Sleeping")!
        }
        DispatchQueue.main.async {
            self.SlothySprite.image = slothSprite
            self.SlothyButton.setImage(slothSprite, for: .normal)
            self.SlothyBubble.isHidden = true
            self.SlothyBubbleLabel.isHidden = true
        }
    }
    
    func slothySleepsInterface() {
        if Thread.isMainThread {
            slothySleepsInterfaceInner()
        } else {
            DispatchQueue.main.async {
                self.slothySleepsInterfaceInner()
            }
        }
    }
    
    func slothyIdleInterfaceInner() {
        var slothSprite: UIImage
        
        if(slothy!.happy) {
            if(slothy!.sex == .male) {
                slothSprite = UIImage(named: "Male Slothy Idle")!
            } else {
                slothSprite = UIImage(named: "Female Slothy Idle")!
            }
        } else {
            if buttonsWorking {
                SlothyBubble.isHidden = false
                SlothyBubbleLabel.isHidden = false
                if slothy!.hunger < Sloth.hungerMaxValue * 0.3 {
                    SlothyBubbleLabel.text = "I'm hungry!"
                } else if slothy!.sleep < Sloth.sleepMaxValue * 0.3 {
                    SlothyBubbleLabel.text = "I'm sleepy!"
                } else {
                    SlothyBubbleLabel.text = "I'm slothful!"
                }
            }
            if(slothy!.sex == .male) {
                slothSprite = UIImage(named: "Male Slothy Dying")!
            } else {
                slothSprite = UIImage(named: "Female Slothy Dying")!
            }
        }
        SlothySprite.image = slothSprite
        SlothyButton.setImage(slothSprite, for: .normal)
    }
    
    func slothyIdleInterface() {
        if Thread.isMainThread {
            slothyIdleInterfaceInner()
        } else {
            DispatchQueue.main.async {
                self.slothyIdleInterfaceInner()
            }
        }
    }
    
    func slothyDiesInterfaceInner() {
        var slothSprite: UIImage
        
        if(slothy!.sex == .male) {
            slothSprite = UIImage(named: "Male Slothy Dead")!
        } else {
            slothSprite = UIImage(named: "Female Slothy Dead")!
        }
        DispatchQueue.main.async {
            self.SlothySprite.image = slothSprite
            self.SlothyButton.setImage(slothSprite, for: .normal)
            self.SlothyBubble.isHidden = true
            self.SlothyBubbleLabel.isHidden = true
        }
    }
    
    func slothyDiesInterface() {
        if Thread.isMainThread {
            slothyDiesInterfaceInner()
        } else {
            DispatchQueue.main.async {
                self.slothyDiesInterfaceInner()
            }
        }
    }
    
    @IBAction func feedButtonPressed(_ sender: Any) {
        NetworkHandler.singleton.requestFeedSloth(room: room!, slothy: slothy!) { (result: (room: RoomGroup?, slothy: Sloth?)?, err: String?) in
            if let err = err {
                if self.slothy!.state != .dead && err == "could not feed slothy" {
                    DispatchQueue.main.async {
                        self.SlothyBubbleLabel.text = "I'm full!"
                        self.SlothyBubbleLabel.isHidden = false
                        self.SlothyBubble.isHidden = false
                    }
                } else {
                    print(err)
                }
            }else{
                self.room!.copyFrom(room: result!.room!)
                self.slothy = result!.slothy!
                self.updateBars(anime: true)
                self.slothyEatsInterface()
            }
        }
    }
    
    @IBAction func sleepButtonPressed(_ sender: Any) {
        NetworkHandler.singleton.requestSleepSloth(room: room!, slothy: slothy!) { (result: (room:RoomGroup?, slothy: Sloth?)?, err:String?) in
            if let err = err {
                if self.slothy!.state != .dead && err == "could not feed slothy" {
                    DispatchQueue.main.async {
                        self.SlothyBubbleLabel.text = "I just woke up!"
                        self.SlothyBubbleLabel.isHidden = false
                        self.SlothyBubble.isHidden = false
                    }
                } else {
                    print(err)
                }
            }else{
                self.room!.copyFrom(room: result!.room!)
                self.slothy = result!.slothy!
                self.updateBars(anime: true)
                self.slothySleepsInterface()
            }
        }
    }
    
    @IBAction func slothyStoreButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "ToSlothyStoreScreen", sender: self)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let storeDisplay = segue.destination as? SlothyStoreViewController{
            storeDisplay.receiveData(room: room!, player: player!)
        }
    }
    

}
