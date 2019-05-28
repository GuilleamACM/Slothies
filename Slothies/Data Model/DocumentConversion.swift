//
//  DocumentConversion.swift
//  Slothies
//
//  Created by Lucas Miranda Lin on 27/05/19.
//  Copyright © 2019 Slothies Inc. All rights reserved.
//

import Foundation

extension RoomGroup {
    
    //dictionary for roomgroup
    var dictionary: [String: Any] {
        
        var playersUser:[String] = []
        var playersLastUpdate:[TimeInterval] = []
        var playersCoins:[Int] = []
        
        for player in self.players{
            if let player = player {
                playersUser.append(player.user)
                playersLastUpdate.append(player.lastUpdate.timeIntervalSince1970)
                playersCoins.append(player.coins)
            } else {
                playersUser.append("")
                playersLastUpdate.append(-1)
                playersCoins.append(-1)
            }
        }

        var slothiesName:[String] = []
        var slothiesSex:[String] = []
        var slothiesState:[String] = []
        var slothiesHunger:[Double] = []
        var slothiesSleep:[Double] = []
        var slothiesLastFed:[TimeInterval] = []
        var slothiesLastSlept:[TimeInterval] = []
        var slothiesLastUpdate:[TimeInterval] = []
        var slothiesSloth:[Double] = []
        
        for sloth in self.slothGroup.slothies{
            if let sloth = sloth{
                slothiesName.append(sloth.name)
                slothiesSex.append(sloth.sex.rawValue)
                slothiesState.append(sloth.state.rawValue)
                slothiesHunger.append(sloth.hunger)
                slothiesSleep.append(sloth.sleep)
                if let lastFed = sloth.lastFed?.timeIntervalSince1970 {
                    slothiesLastFed.append(lastFed)
                }else{
                    slothiesLastFed.append(-1)
                }
                if let lastSlept = sloth.lastSlept?.timeIntervalSince1970{
                    slothiesLastSlept.append(lastSlept)
                }else{
                    slothiesLastSlept.append(-1)
                }
                slothiesLastUpdate.append(sloth.lastUpdate.timeIntervalSince1970)
                slothiesSloth.append(sloth.sloth)
            }else{
                slothiesName.append("")
                slothiesSex.append("")
                slothiesState.append("")
                slothiesHunger.append(-1)
                slothiesSleep.append(-1)
                slothiesLastFed.append(-1)
                slothiesLastSlept.append(-1)
                slothiesLastUpdate.append(-1)
                slothiesSloth.append(-1)
            }
        }
        
        func Slothy(val:Int) ->[String:Any]{
            return ["name": slothiesName[val],
             "sex":slothiesSex[val],
             "state":slothiesState[val],
             "hunger":slothiesHunger[val],
             "sleep":slothiesSleep[val],
             "lastFed":slothiesLastFed[val],
             "lastSlept":slothiesLastSlept[val],
             "lastUpdate":slothiesLastUpdate[val],
             "sloth":slothiesSloth[val]]
        }
        
        func Players(val:Int) -> [String:Any]{
            return ["user":playersUser[val],
                    "lastUpdate":playersLastUpdate[val],
                    "coins":playersCoins[val]]
        }
        
        return [
            "roomName":name,
            "roomPass":pass,
            "roomPrevTime":prevTime.timeIntervalSince1970,
            "slothGroupFood":slothGroup.food,
            "slothGroupDistanceAccu": slothGroup.distanceAccu,
            "player0": Players(val: 0),
            "player1": Players(val: 1),
            "player2": Players(val: 2),
            "player3": Players(val: 3),
            "sloth0": Slothy(val:0),
            "sloth1": Slothy(val:1),
            "sloth2": Slothy(val:2),
            "sloth3": Slothy(val:3),
        ]
    }
    
    convenience init? (dictionary: [String:Any]){
        
        guard let roomName = dictionary["roomName"] as? String,
            let roomPass = dictionary["roomPass"] as? String,
            let roomPrevTime = dictionary["roomPrevTime"] as? TimeInterval,
            let slothGroupFood = dictionary["slothGroupFood"] as? Int,
            let slothGroupDistanceAccu = dictionary["slothGroupDistanceAccu"] as? Double,
            let player0 = dictionary["player0"] as? [String:Any],
            let player1 = dictionary["player1"] as? [String:Any],
            let player2 = dictionary["player2"] as? [String:Any],
            let player3 = dictionary["player3"] as? [String:Any],
            let sloth0 = dictionary["sloth0"] as? [String:Any],
            let sloth1 = dictionary["sloth1"] as? [String:Any],
            let sloth2 = dictionary["sloth2"] as? [String:Any],
            let sloth3 = dictionary["sloth3"] as? [String:Any]
            else{
                return nil
        }
        
        guard let player0User = player0["user"] as? String,
            let player0LastUpdate = player0["lastUpdate"] as? TimeInterval,
            let player0Coins = player0["coins"] as? Int,
            
            let player1User = player1["user"] as? String,
            let player1LastUpdate = player1["lastUpdate"] as? TimeInterval,
            let player1Coins = player1["coins"] as? Int,
            
            let player2User = player2["user"] as? String,
            let player2LastUpdate = player2["lastUpdate"] as? TimeInterval,
            let player2Coins = player2["coins"] as? Int,
            
            let player3User = player3["user"] as? String,
            let player3LastUpdate = player3["lastUpdate"] as? TimeInterval,
            let player3Coins = player3["coins"] as? Int
            else{
                return nil
        }
        
        guard let sloth0Name = sloth0["name"] as? String,
            let sloth0Sex = sloth0["sex"] as? String,
            let sloth0State = sloth0["state"] as? String,
            let sloth0Hunger = sloth0["hunger"] as? Double,
            let sloth0Sleep = sloth0["sleep"] as? Double,
            let sloth0LastFed = sloth0["lastFed"] as? TimeInterval,
            let sloth0LastSlept = sloth0["lastSlept"] as? TimeInterval,
            let sloth0LastUpdate = sloth0["lastUpdate"] as? TimeInterval,
            let sloth0Sloth = sloth0["sloth"] as? Double,
            
            let sloth1Name = sloth1["name"] as? String,
            let sloth1Sex = sloth1["sex"] as? String,
            let sloth1State = sloth1["state"] as? String,
            let sloth1Hunger = sloth1["hunger"] as? Double,
            let sloth1Sleep = sloth1["sleep"] as? Double,
            let sloth1LastFed = sloth1["lastFed"] as? TimeInterval,
            let sloth1LastSlept = sloth1["lastSlept"] as? TimeInterval,
            let sloth1LastUpdate = sloth1["lastUpdate"] as? TimeInterval,
            let sloth1Sloth = sloth1["sloth"] as? Double,
        
            let sloth2Name = sloth2["name"] as? String,
            let sloth2Sex = sloth2["sex"] as? String,
            let sloth2State = sloth2["state"] as? String,
            let sloth2Hunger = sloth2["hunger"] as? Double,
            let sloth2Sleep = sloth2["sleep"] as? Double,
            let sloth2LastFed = sloth2["lastFed"] as? TimeInterval,
            let sloth2LastSlept = sloth2["lastSlept"] as? TimeInterval,
            let sloth2LastUpdate = sloth2["lastUpdate"] as? TimeInterval,
            let sloth2Sloth = sloth2["sloth"] as? Double,
        
            let sloth3Name = sloth3["name"] as? String,
            let sloth3Sex = sloth3["sex"] as? String,
            let sloth3State = sloth3["state"] as? String,
            let sloth3Hunger = sloth3["hunger"] as? Double,
            let sloth3Sleep = sloth3["sleep"] as? Double,
            let sloth3LastFed = sloth3["lastFed"] as? TimeInterval,
            let sloth3LastSlept = sloth3["lastSlept"] as? TimeInterval,
            let sloth3LastUpdate = sloth3["lastUpdate"] as? TimeInterval,
            let sloth3Sloth = sloth3["sloth"] as? Double
            else{
                return nil
        }
        
        //agora comeca a putaria
        
        
        self.init(name: <#T##String#>, pass: <#T##String#>)
    }
}
