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
        let tempRoom = RoomGroup(name: "room", pass: "pass")
        
        let sloth1 = Player(username: "sloth1" , pass: "s1")
        accounts.append(sloth1)
        let sloth2 = Player(username: "sloth2" , pass: "s2")
        accounts.append(sloth2)
        let sloth3 = Player(username: "sloth3" , pass: "s3")
        accounts.append(sloth3)
        
        tempRoom.players.append(sloth1)
        tempRoom.players.append(sloth2)
        tempRoom.players.append(sloth3)
        
        rooms.append(tempRoom)

        
        

    }
}
