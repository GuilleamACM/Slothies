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
    var food = 0
    var coins = 0

    @IBOutlet weak var SlothometerUIProgressView: UIProgressView!
    
    @IBOutlet weak var FoodLabel: UILabel!
    
    @IBOutlet weak var SlothyCoinsLabel: UILabel!
    
    @IBOutlet var SlothyButtons: [UIButton]!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateInterface()
        navigationController!.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        food = 100
        coins = 100
        updateInterface()
        navigationController!.setNavigationBarHidden(true, animated: true)
    }
    
    func updateInterface() {
        FoodLabel.text = "\(food)"
        SlothyCoinsLabel.text = "\(coins)"
        SlothometerUIProgressView.setProgress(Float(slothometer!.totalValue / Slothometer.maxValue), animated: true)
        loadRoom()
    }
    
    func loadRoom() {
        for (index, player) in room!.players.enumerated() {
            SlothyButtons[index].setBackgroundImage(nil, for: .normal)
            if let label = SlothyButtons[index].titleLabel {
                label.text = ""
            }
            if let _ = player {
                let image = UIImage(named: "Slothy\(index+1) Face")
                SlothyButtons[index].setImage(image, for: .normal)
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
