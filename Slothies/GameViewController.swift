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
    var slothometer: Slothometer?
    var food = 0
    var coins = 0

    @IBOutlet weak var SlothometerUIProgressView: UIProgressView!
    
    @IBOutlet weak var FoodLabel: UILabel!
    
    @IBOutlet weak var SlothyCoinsLabel: UILabel!
    
    @IBOutlet var SlothyButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        food = 100
        coins = 100
        updateInterface()
    }
    
    func updateInterface() {
        FoodLabel.text = "\(food)"
        SlothyCoinsLabel.text = "\(coins)"
        SlothometerUIProgressView.setProgress(Float(slothometer!.totalValue / Slothometer.maxValue), animated: true)
        loadRoom()
    }
    
    func loadRoom() {
        for (index, player) in room!.players.enumerated() {
            if let _ = player {
                let image = UIImage(named: "Slothy\(index+1) Face")
                SlothyButtons[index].setBackgroundImage(nil, for: .normal)
                SlothyButtons[index].setImage(image, for: .normal)
            }
        }
    }
    
    func receiveData(room: RoomGroup) {
        self.room = room
        self.slothometer = room.slothGroup.slothometer
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
