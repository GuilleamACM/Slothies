//
//  UpdateLogic.swift
//  Slothies
//
//  Created by Lucas Miranda Lin on 27/05/19.
//  Copyright © 2019 Slothies Inc. All rights reserved.
//

import Foundation

extension RoomGroup {
    private static let walkMultiplier = 500.0
    
    private func coinsFromSteps(_ steps: Double) -> Int {
        return Int(steps / 500.0)
    }
    
    func updateWithPlayerHealthInfo (_ playerFromArgument: Player) -> String? {
        if dead {
            return "ded"
        }
        var playerToUpdate: Player? = nil
        for play in players {
            if let play = play {
                if play == playerFromArgument {
                    playerToUpdate = play
                }
            }
        }
        
        let currentTime = Date()
        guard let play = playerToUpdate else {
            return "could not find player"
        }
        guard let info = play.getHealthData(currentTime) else {
            return "could not get player health"
        }
        
        timePassageUpdate(currentTime)
        play.updateWalked(currTime: currentTime, info: (steps: info.steps * RoomGroup.walkMultiplier, distance: info.distance * RoomGroup.walkMultiplier))
        play.awardCoins(coins: coinsFromSteps(info.steps * RoomGroup.walkMultiplier))
        dead = slothGroup.checkDeath()
        slothGroup.walked(distance: info.distance)
        return nil
    }
    
    func updateWithPretendData (_ playerFromArgument: Player, steps: Double, distance: Double) -> String? {
        var playerToUpdate: Player? = nil
        for play in players {
            if let play = play {
                if play == playerFromArgument {
                    playerToUpdate = play
                }
            }
        }
        
        let currentTime = Date()
        guard let play = playerToUpdate else {
            return "could not find player"
        }
        let info = (steps: steps, distance: distance)
        
        play.updateWalked(currTime: currentTime, info: (steps: info.steps * RoomGroup.walkMultiplier, distance: info.distance * RoomGroup.walkMultiplier))
        play.awardCoins(coins: coinsFromSteps(info.steps * RoomGroup.walkMultiplier))
        dead = slothGroup.checkDeath()
        slothGroup.walked(distance: info.distance)
        return nil
    }
    
    func updateTimeOnly (_ currentTime: Date) {
        timePassageUpdate(currentTime)
        dead = slothGroup.checkDeath()
    }
    
    //update to call upon opening the app/joining the room
    fileprivate func timePassageUpdate (_ currentTime: Date) {
        slothGroup.timePassageUpdate(prevTime: prevTime, currTime: currentTime)
        prevTime = currentTime
    }
}

extension Player {
    //fetch user's activity since previous access and update sloth with it
    fileprivate func updateWalked (currTime: Date, info: (steps: Double, distance: Double)) {
        if let slothy = slothy {
            slothy.updateWalked(currTime: currTime, info: info)
        }
    }
}

extension SlothGroup {
    fileprivate func timePassageUpdate (prevTime: Date, currTime: Date) {
        slothometer.timePassageUpdate(prevTime: prevTime, currTime: currTime)
        for maybeSlothy in slothies {
            if let slothy = maybeSlothy {
                slothy.updateHungerSleep(prevTime: prevTime, currTime: currTime)
            }
        }
    }
}

extension Sloth {
    fileprivate func updateWalked (currTime: Date, info: (steps: Double, distance: Double)) {
        if let slothometer = slothometer {
            slothometer.updateWalked(slothy: self, info: info)
        }
    }
    
    fileprivate func updateHungerSleep(prevTime: Date, currTime: Date) {
        let elapsed = Double(currTime.timeIntervalSince(prevTime))
        
        switch state {
        case .sleeping:
            sleep += elapsed * Sloth.sleepingMultiplier
            if sleep >= Sloth.sleepMaxValue {
                sleep = Sloth.sleepMaxValue
                state = .idle
            }
            hunger -= elapsed
            break
        case .eating:
            sleep -= elapsed
            hunger -= elapsed
            if Sloth.feedingCooldown < currTime.timeIntervalSince(lastFed!) {
                state = .idle
            }
            break
        case .dead:
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
        individualValues[slothy] = result
        updateTotalValue()
    }
    
    //subtract seconds passed from values
    fileprivate func timePassageUpdate (prevTime: Date, currTime: Date) {
        //BUG: elapsed should consider each slothy's individual prevTime
        let elapsed = Double(currTime.timeIntervalSince(prevTime))
        individualValues.keys.forEach {
            var multiplier = 1.0
            if $0.sleep < Sloth.sleepMaxValue * 0.3 {
                multiplier *= 2
            } else if $0.sleep == 0 {
                multiplier *= 3
            }
            if $0.hunger < Sloth.hungerMaxValue * 0.3 {
                multiplier *= 2
            } else if $0.hunger == 0 {
                multiplier *= 3
            }
            
            addSpecificValue(slothy: $0, val: -(elapsed * multiplier))
        }
    }
    
    //check workout information, sum appropriate number into values
    fileprivate func updateWalked (slothy: Sloth, info: (steps: Double,distance: Double)) {
        //TODO: check workout information to see if everything is okay
        let stepsPercent = info.steps/stepsHealthPerDay
        let slothmeters = stepsPercent*secondsPerDay
        
        addSpecificValue(slothy: slothy, val: slothmeters)
        //TODO: better define sloth reward for working out
        
        updateTotalValue()
    }
}
