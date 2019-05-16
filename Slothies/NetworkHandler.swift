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


class NetworkHandler {
    //classe que deve conter qualquer método para o qual espera-se acessar a rede
    static let singleton: NetworkHandler = NetworkHandler()
    
    func fetchRoom(na: String, pa: String) -> RoomGroup? {
        return tempStaticRoom
    }
    
    init() {
        for (index, player) in accounts.enumerated() {
            tempStaticRoom.createSloth(player: player, name: "player"+String(index), sex: .male, index: index )
        }
    }
}
