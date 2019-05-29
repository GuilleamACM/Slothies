//
//  GameViewController.swift
//  Slothies
//
//  Created by Lucas Miranda Lin on 13/05/19.
//  Copyright © 2019 Slothies Inc. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, GameDataUpdateable {
    
    func completionUpdateInterface(room: RoomGroup?, err: String?) {
        if let room = room {
            self.room!.copyFrom(room: room)
            loadRoom()
        } else {
            print(err!)
        }
    }
    
    var room: RoomGroup?
    var player: Player?
    var slothometer: Slothometer?

    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var alertBlur: UIView!
    
    @IBOutlet weak var walkedStepsLabel: UILabel!
    
    @IBOutlet weak var rewardsLabel: UILabel!
    
    @IBOutlet weak var appleImage: UIImageView!
    
    @IBOutlet weak var appleCountLabel: UILabel!
    
    @IBOutlet weak var coinImage: UIImageView!
    
    @IBOutlet weak var coinCountLabel: UILabel!
    
    @IBOutlet weak var SlothometerUIProgressView: UIProgressView!
    
    @IBOutlet weak var FoodLabel: UILabel!
    
    @IBOutlet weak var SlothyCoinsLabel: UILabel!
    
    @IBOutlet var SlothyButtons: [UIButton]!
    
    @IBOutlet var SlothyNameLabels: [UILabel]!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController!.setNavigationBarHidden(true, animated: false)
        //room = NetworkHandler.singleton.fetchRoom(code: room!.name, pass: room!.pass)
        NetworkHandler.listenerDispatch = self
        player = room!.getPlayer(withUser: player!.user)
        slothometer = room!.slothGroup.slothometer
        updateInterface()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkHandler.listenerDispatch = self
        NetworkHandler.singleton.initiateListening(room: room!)
        initiatePeriodicUpdating()
        DispatchQueue.main.async {
            self.SlothometerUIProgressView.layer.cornerRadius = 10
            self.SlothometerUIProgressView.layer.masksToBounds = true
            self.showAlert(steps: 1000, food: 10, coins: 5)
            self.SlothometerUIProgressView.transform = self.SlothometerUIProgressView.transform.scaledBy(x: 1, y: 4)
            self.updateInterface()
            self.navigationController!.setNavigationBarHidden(true, animated: true)
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
            self.view.addGestureRecognizer(tap)
        }
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        closeAlert()
    }
    
    private static let updateInterval: Double = secondsPerMinute * 10
    
    func initiatePeriodicUpdating() {
        Timer.scheduledTimer(withTimeInterval: GameViewController.updateInterval, repeats: false) { (timer) in
            NetworkHandler.singleton.requestUpdate(room: self.room!, player: self.player!, completion: { (result: (room: RoomGroup, player: Player)?, err) in
                if let err = err {
                    print(err)
                    return
                }
                if let result = result {
                    self.room!.copyFrom(room: result.room)
                    self.player = result.player
                    self.loadRoom()
                }
            })
        }
    }
    
    func showAlertInner(steps: Int, food:Int, coins:Int) {
        alertView.layer.cornerRadius = 10
        alertView.layer.masksToBounds = true
        alertView.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0)
        alertBlur.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        alertBlur.addSubview(blurEffectView)
        walkedStepsLabel.text = "You walked \(steps) steps"
        appleCountLabel.text = "+ \(food)"
        coinCountLabel.text = "+ \(coins)"
    }
    
    func showAlert(steps: Int, food: Int, coins: Int) {
        if Thread.isMainThread {
            showAlertInner(steps: steps, food: food, coins: coins)
        } else {
            DispatchQueue.main.async {
                self.showAlertInner(steps: steps, food: food, coins: coins)
            }
        }
    }
    
    func closeAlert() {
        if Thread.isMainThread {
            alertView.alpha = 0
        } else {
            DispatchQueue.main.async {
                self.alertView.alpha = 0
            }
        }
    }
    
    func updateInterfaceInner() {
        FoodLabel.text = "\(room!.slothGroup.food)"
        SlothometerUIProgressView.setProgress(Float(slothometer!.totalValue / Slothometer.maxValue), animated: true)
        if (SlothometerUIProgressView.progress >= 0.7) {
            SlothometerUIProgressView.progressTintColor = .green
        } else if SlothometerUIProgressView.progress >= 0.3 {
            SlothometerUIProgressView.progressTintColor = .yellow
        } else {
            SlothometerUIProgressView.progressTintColor = .red
        }
        loadRoom()
    }
    
    func updateInterface() {
        if Thread.isMainThread {
            updateInterfaceInner()
        } else {
            DispatchQueue.main.async {
                self.updateInterfaceInner()
            }
        }
    }
    
    func loadRoomInner() {
        for (index, player) in room!.players.enumerated() {
            SlothyButtons[index].setBackgroundImage(nil, for: .normal)
            if let _ = player {
                let image: UIImage
                if (room!.getSlothy(index: index)!.sex == .male) {
                    image = UIImage(named: "Male Slothy Face Idle")!
                } else {
                    image = UIImage(named: "Female Slothy Face Idle")!
                }
                SlothyButtons[index].setImage(image, for: .normal)
                SlothyNameLabels[index].text = room!.getSlothy(index: index)!.name
            } else {
                SlothyNameLabels[index].text = ""
            }
        }
    }
    
    func loadRoom() {
        if Thread.isMainThread {
            loadRoomInner()
        } else {
            DispatchQueue.main.async {
                self.loadRoomInner()
            }
        }
    }
    
    var slothDisplaySlothy: Sloth?
    
    func slothyPressed(index: Int) {
        if let slothy = room!.getSlothy(index: index) {
            DispatchQueue.main.async {
                self.slothDisplaySlothy = slothy
                self.performSegue(withIdentifier: "ToSlothDisplayScreen", sender: self)
            }
        }
    }

    @IBAction func slothyPressed0(_ sender: Any) {
        slothyPressed(index: 0)
    }
    @IBAction func slothyPressed1(_ sender: Any) {
        slothyPressed(index: 1)
    }
    @IBAction func slothyPressed2(_ sender: Any) {
        slothyPressed(index: 2)
    }
    @IBAction func slothyPressed3(_ sender: Any) {
        slothyPressed(index: 3)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let slothyDisplay = segue.destination as? SlothDisplayViewController {
            slothyDisplay.receiveData(room: room!, slothy: slothDisplaySlothy!, player: player!)
        }
    }
    
    @IBAction func helpButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "ToTutorialScreen", sender: self)
    }
    
    func receiveData(room: RoomGroup, player: Player) {
        self.room = room
        self.player = player
        self.slothometer = room.slothGroup.slothometer
    }
}
