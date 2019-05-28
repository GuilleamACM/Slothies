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
        return [
            "name":name,
            "pass":pass,
            "players": [], //TODO credential IDTOKEN
            "prevTime":prevTime.timeIntervalSince1970,
            "slothGroup":slothGroup.getSlothiesName()
        ]
    }
    
    convenience init? (dictionary: [String:Any]){
        guard let name = dictionary["name"] as? String,
            let pass = dictionary["pass"] as? String,
            //let players
            let interval = dictionary["prevTime"] as? TimeInterval,
            let slothGroup = dictionary["slothGroup"] as? String
            else{ return nil }
        
        self.init(name: name, pass: pass)
        self.prevTime = Date(timeIntervalSince1970: interval)
        // self.players = players TODO
        //self.slothGroup = slothGroup TODO
}
}
/*
 roomgroup.setData([
 room name : String
 room pass : String
 room prevtime
 slothgroup food
 slothgroup distance
 //if user = "" -> user = nil
 //if name = "" -> sloth = nil
 player0:  [user, lastUpdate, coins]
 player1:  [user, lastUpdate, coins]
 player2:  [user, lastUpdate, coins]
 player3:  [user, lastUpdate, coins]
 sloth0 : [name, sex, hunger, sleep, lastupdate, lastfed, lastslept, sloth]
 sloth1: [name, sex, hunger, sleep, lastupdate, lastfed, lastslept, sloth]
 sloth2: [name, sex, hunger, sleep, lastupdate, lastfed, lastslept, sloth]
 sloth3: [name, sex, hunger, sleep, lastupdate, lastfed, lastslept, sloth]
 ])
 */
