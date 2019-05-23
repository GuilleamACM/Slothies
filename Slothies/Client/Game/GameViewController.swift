//
//  GameViewController.swift
//  Slothies
//
//  Created by Lucas Miranda Lin on 13/05/19.
//  Copyright © 2019 Slothies Inc. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
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
        room = NetworkHandler.singleton.fetchRoom(code: room!.name, pass: room!.pass)
        player = room!.getPlayer(withName: player!.identifier)
        slothometer = room!.slothGroup.slothometer
        updateInterface()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateInterface()
        navigationController!.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAlert(steps: 1000, food: 10, coins: 5)
        updateInterface()
        navigationController!.setNavigationBarHidden(true, animated: true)
    }
    
    func showAlert(steps: Int, food:Int, coins:Int) {
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
    
    func closeAlert() {
        
    }
    
    func updateInterface() {
        FoodLabel.text = "\(room!.slothGroup.food)"
        SlothometerUIProgressView.setProgress(Float(slothometer!.totalValue / Slothometer.maxValue), animated: true)
        loadRoom()
    }
    
    func loadRoom() {
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
    
    var slothDisplaySlothy: Sloth?
    
    func slothyPressed(index: Int) {
        if let slothy = room!.getSlothy(index: index) {
            slothDisplaySlothy = slothy
            performSegue(withIdentifier: "ToSlothDisplayScreen", sender: self)
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
    
    
    func receiveData(room: RoomGroup, player: Player) {
        self.room = room
        self.player = player
        self.slothometer = room.slothGroup.slothometer
    }
}
