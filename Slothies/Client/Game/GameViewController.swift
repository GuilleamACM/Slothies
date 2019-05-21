//
//  GameViewController.swift
//  Slothies
//
//  Created by Lucas Miranda Lin on 13/05/19.
//  Copyright © 2019 Slothies Inc. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    private static let updateInterval: Double = secondsPerMinute * 10
    
    var room: RoomGroup?
    var player: Player?
    var slothometer: Slothometer?

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
        navigationController!.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateInterface()
        initiatePeriodicUpdating()
        navigationController!.setNavigationBarHidden(true, animated: true)
    }
    
    func initiatePeriodicUpdating() {
        Timer.scheduledTimer(withTimeInterval: GameViewController.updateInterval, repeats: true, block: { (timer) in
            if let netRoom = NetworkHandler.singleton.fetchRoom(code: self.room!.name, pass: self.room!.pass) {
                self.room!.copyFrom(room: netRoom)
                self.updateInterface()
            }
        })
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
