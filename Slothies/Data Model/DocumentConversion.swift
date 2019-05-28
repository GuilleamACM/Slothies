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
        let playersDictionary = [player0,player1,player2,player3]
        let slothiesDictionary = [sloth0,sloth1,sloth2,sloth3]
        var players:[Player?] = [Player?](repeating: nil, count: 4)
        self.init(name: roomName, pass: roomPass)
        self.prevTime = Date(timeIntervalSince1970: roomPrevTime)
        
        for i in [0,1,2,3]{
            if let user = playersDictionary[i]["user"] as? String{
                if(user != ""){
                    players[i] = Player(user:user)
                    guard let lastUpdatePlayer =  playersDictionary[i]["lastUpdate"] as? TimeInterval,
                        let coins = playersDictionary[i]["coins"] as? Int
                        else{
                            return nil
                    }
                    players[i]!.lastUpdate = Date(timeIntervalSince1970: lastUpdatePlayer)
                    players[i]!.coins = coins
                    guard let name = slothiesDictionary[i]["name"] as? String,
                        let sex = slothiesDictionary[i]["sex"] as? String,
                        let state = slothiesDictionary[i]["state"] as? String,
                        let hunger = slothiesDictionary[i]["hunger"] as? Double,
                        let sleep = slothiesDictionary[i]["sleep"] as? Double,
                        let lastFed = slothiesDictionary[i]["lastFed"] as? TimeInterval,
                        let lastSlept = slothiesDictionary[i]["lastSlept"] as? TimeInterval,
                        let lastUpdateSloth = slothiesDictionary[i]["lastUpdate"] as? TimeInterval,
                        let sloth = slothiesDictionary[i]["sloth"] as? Double
                        else{
                            return nil
                    }
                    self.createSloth(player: players[i]!, name: name, sex: Sex(rawValue: sex)!, index: i)
                    self.slothGroup.slothies[i]!.state = State(rawValue:state)!
                    self.slothGroup.slothies[i]!.hunger = hunger
                    self.slothGroup.slothies[i]!.sleep = sleep
                    if(lastFed != -1){
                        self.slothGroup.slothies[i]!.lastFed = Date(timeIntervalSince1970: lastFed)
                    }else{
                        self.slothGroup.slothies[i]!.lastFed = nil
                    }
                    if(lastSlept != -1){
                        self.slothGroup.slothies[i]!.lastSlept = Date(timeIntervalSince1970: lastSlept)
                    }else{
                        self.slothGroup.slothies[i]!.lastSlept = nil
                    }
                    self.slothGroup.slothies[i]!.lastUpdate = Date(timeIntervalSince1970: lastUpdateSloth)
                    self.slothGroup.slothometer.individualValues[self.slothGroup.slothies[i]!] = sloth
                    
                }else{
                    players[i] = nil
                }
            }else{
                return nil
            }
        }
        
        self.slothGroup.food = slothGroupFood
        self.slothGroup.distanceAccu = slothGroupDistanceAccu
        self.slothGroup.slothometer.updateTotalValue()
        
    }
}
/*
 roomName = String
 roomPass = String
 roomPlayers = [Players?]
 roomPrevTime = Date
 slothgroup = SlothGroup
 
 playerUser = String
 playerUpdate = Date
 playerCoins = Int
 
 slothgroup
 slothies = [Sloth?]
 food = [int]
 distanceAccu = [double]
 
 slothy
 name = String
 sex = Enum Sex
 hunger = Double
 sleep = Double
 lastUpdate = Date
 lastFed = Date?
 lastSlept = Date?
 state = Enum State

 
 Slothometer
 invidual values =  Dictionary<Sloth, Double>
 total Value = Double */
