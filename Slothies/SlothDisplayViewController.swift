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
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    @objc
    func handleGesture(gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .left:
            moveLeft()
            break
        case .right:
            moveRight()
            break
        default:
            let _ = 1 + 1
        }
        updateInterface()
    }
    
    func moveLeft() {
        if var index = slothIndex {
            index = index - 1
            while(index > -1) {
                if let roo = room {
                    if let _ = roo.players[index] {
                        slothIndex = index
                        updateInterface()
                        return
                    }
                }
            }
        }
    }
    
    func moveRight() {
        if var index = slothIndex {
            index = index + 1
            while(index < maxPlayers) {
                if let roo = room {
                    if let _ = roo.players[index] {
                        slothIndex = index
                        updateInterface()
                        return
                    }
                }
            }
        }
    }
    
    func updateInterface () {
        if let room = room {
            pageControl.numberOfPages = room.players.count
            if let index = slothIndex {
                pageControl.currentPage = index
                if let slothy = room.slothGroup.slothies[index] {
                    SlothyNameLabel.text = slothy.name
                    HungerProgressBar.progress = Float(slothy.hunger / Sloth.statusMaxValue)
                    SleepProgressBar.progress = Float(slothy.sleep / Sloth.statusMaxValue)
                    SlothometerProgressBar.progress = Float(slothy.sloth / Slothometer.maxValue)
                }
            }
        }
    }
    
    func receiveData(room: RoomGroup, slothIndex: Int) {
        assert(slothIndex >= 0 && slothIndex < maxPlayers)
        self.room = room
        self.slothIndex = slothIndex
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
