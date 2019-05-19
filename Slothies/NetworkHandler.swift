//
//  NetworkHandler.swift
//  Slothies
//
//  Created by cub on 15/05/19.
//  Copyright © 2019 Slothies Inc. All rights reserved.
//

import UIKit

var accounts: [Player] = []
var rooms: [RoomGroup] = []

class NetworkHandler {
    //classe que deve conter qualquer método para o qual espera-se acessar a rede
    static let singleton: NetworkHandler = NetworkHandler()

    
    func fetchRoom(code: String, pass: String) -> RoomGroup? {
        if let index = rooms.firstIndex(where: {$0.name == code && $0.pass == pass}) {
            return rooms[index]
        }
        return nil
    }
    
    func fetchPlayer(username: String, pass: String) -> Player? {
        if let index = accounts.firstIndex(where: {$0.identifier == username && $0.password == pass}) {
            return accounts[index]
        }
        return nil

    }
    
    init() {
        print("calling NetworkHandler INIT")
        let tempRoom = RoomGroup(name: "room", pass: "pass")
        
        let p1 = Player(username: "player1" , pass: "p1")
        accounts.append(p1)
        
        let p2 = Player(username: "player2" , pass: "p2")
        tempRoom.createSloth(player: p2, name: "sloth2", sex: .female
            , index: 1)
        accounts.append(p2)
        
        let p3 = Player(username: "player3" , pass: "p3")
        tempRoom.createSloth(player: p3, name: "sloth3", sex: .male
            , index: 2)
        accounts.append(p3)
        
        rooms.append(tempRoom)

        
        

    }
}
