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
    
    var room: RoomGroup?
    var slothy: Sloth?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StatusContainerView.layer.cornerRadius = 10
        StatusContainerView.layer.masksToBounds = true
    }
    
    func updateBars (anime: Bool) {
        HungerProgressBar.setProgress(Float(slothy!.hunger / Sloth.statusMaxValue), animated: anime)
        SleepProgressBar.setProgress(Float(slothy!.sleep / Sloth.statusMaxValue), animated: anime)
        SlothometerProgressBar.setProgress(Float(slothy!.sloth / Slothometer.maxValue), animated: anime)
    }
    
    func firstUpdateInterface () {
        if let slothy = slothy {
            SlothyNameLabel.text = slothy.name
            updateBars(anime: false)
        }
    }
    
    func updateInterface () {
        updateBars(anime: true)
    }
    
    func receiveData(room: RoomGroup, slothy: Sloth) {
        self.room = room
        self.slothy = slothy
        firstUpdateInterface()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
