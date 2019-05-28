//
//  UpdateLogic.swift
//  Slothies
//
//  Created by Lucas Miranda Lin on 27/05/19.
//  Copyright © 2019 Slothies Inc. All rights reserved.
//

import Foundation

extension RoomGroup {
    func updateWithPlayerHealthInfo (player: Player, info: (steps: Double, distance: Double), lastDate: Date) {
        var playerToUpdate: Player? = nil
        for play in players {
            if let play = play {
                if play == player {
                    playerToUpdate = play
                }
            }
        }
        
        update()
        if let play = playerToUpdate {
            play.update(date: lastDate, info: info)
            slothGroup.walked(distance: info.distance)
        }
    }
    
    //update to call upon opening the app/joining the room
    func update () {
        let currentTime = Date()
        slothGroup.update(prevTime: prevTime, currTime: currentTime)
        prevTime = currentTime
    }
}

extension Player {
    //fetch user's activity since previous access and update sloth with it
    fileprivate func update (date: Date, info: (steps: Double, distance: Double)) {
        if let slothy = slothy {
            slothy.updateWithInfo(currTime: date, info: info)
        }
        lastUpdate = date
    }
}

extension SlothGroup {
    fileprivate func update (prevTime: Date, currTime: Date) {
        for maybeSlothy in slothies {
            if let slothy = maybeSlothy {
                slothy.update(currTime)
            }
        }
        slothometer.update(prevTime: prevTime, currTime: currTime)
    }
}

extension Sloth {
    fileprivate func updateWithInfo (currTime: Date, info: (steps: Double, distance: Double)) {
        if let slothometer = slothometer {
            slothometer.updateSpecificValue(slothy: self, info: info)
        }
        update(currTime)
    }
    
    fileprivate func update(_ currTime: Date) {
        let elapsed = Double(currTime.timeIntervalSince(lastUpdate))
        lastUpdate = Date()
        
        switch state {
        case .sleeping:
            sleep += elapsed * Sloth.sleepingMultiplier
            //TODO
            hunger -= elapsed
            break
        case .eating:
            sleep -= elapsed
            hunger -= elapsed
            if Sloth.feedingCooldown < currTime.timeIntervalSince(lastFed!) {
                state = .idle
            }
            break
        default:
            sleep -= elapsed
            hunger -= elapsed
            break
        }
    }
}

extension Slothometer {
    fileprivate func addSpecificValue(slothy: Sloth, val: Double) {
        var result = individualValues[slothy]! + val
        result = min(result, Slothometer.maxValue)
        updateTotalValue()
    }
    
    //subtract seconds passed from values
    fileprivate func update (prevTime: Date, currTime: Date) {
        let elapsed = Double(currTime.timeIntervalSince(prevTime))
        individualValues.keys.forEach {
            addSpecificValue(slothy: $0, val: -elapsed)
        }
        updateTotalValue()
    }
    
    //check workout information, sum appropriate number into values
    fileprivate func updateSpecificValue (slothy: Sloth, info: (steps: Double,distance: Double)) {
        //TODO: check workout information to see if everything is okay
        let stepsPercent = info.steps/stepsHealthPerDay
        let slothmeters = stepsPercent*secondsPerDay
        
        addSpecificValue(slothy: slothy, val: slothmeters)
        //TODO: better define sloth reward for working out
        
        updateTotalValue()
    }
}
