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
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var room: RoomGroup?
    var slothIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StatusContainerView.layer.cornerRadius = 10
        StatusContainerView.layer.masksToBounds = true
    }
    
    func updateInterfaceValues () {
        
        if let room = room {
            if let index = slothIndex {
                let slothy = room.slothGroup.slothies[index]
                SlothyNameLabel.text = slothy.name
                HungerProgressBar.progress = Float(slothy.hunger / Sloth.statusMaxValue)
                SleepProgressBar.progress = Float(slothy.sleep / Sloth.statusMaxValue)
                SlothometerProgressBar.progress = Float(slothy.sloth / Slothometer.maxValue)
            }
        }
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
