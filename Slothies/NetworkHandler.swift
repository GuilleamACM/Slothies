//
//  NetworkHandler.swift
//  Slothies
//
//  Created by cub on 15/05/19.
//  Copyright © 2019 Slothies Inc. All rights reserved.
//

import UIKit

var tempStaticRoom = RoomGroup(na: "room", pa: "pass")
var accounts: [Player] = []
var current_player: Player? = nil


class NetworkHandler {
    //classe que deve conter qualquer método para o qual espera-se acessar a rede
    static let singleton: NetworkHandler = NetworkHandler()

    
    func fetchRoom(na: String, pa: String) -> RoomGroup? {
        return tempStaticRoom
    }
    
    func fetchPlayer(username: String, password: String) -> Bool {
        if accounts.firstIndex(where: {$0.identifier == username && $0.password == password}) != nil {
            current_player = Player(username: username, password: password)
            print("\(username) login ok")
            return true
        }
        return false

    }
    
    init() {
//        for (index, player) in accounts.enumerated() {
//            tempStaticRoom.createSloth(player: player, name: "player"+String(index), sex: .male, index: index )
//        }
    }
}
