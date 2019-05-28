//
//  GroupRoom.swift
//  Slothies
//
//  Created by Lucas Miranda Lin on 13/05/19.
//  Copyright © 2019 Slothies Inc. All rights reserved.
//

import UIKit
import Firebase

class RoomGroup {
    //deve conter informacoes e metodos relacionados a sala, aos jogadores dela, e talvez as preguicas
    
    //estes comentarios foram escritos sem muito pensamento
    //se achar melhor, sinta-se disposto a ignora-los
    
    //nome e senha da sala
    var name: String
    var pass: String
    
    //lista de jogadores
    var players: [Player?]
    
    //data de último acesso ao aplicativo, use para atualizar preguiçometro
    var prevTime: Date
    
    //referencia ao grupo de preguiças
    var slothGroup: SlothGroup
    
    init (name:String, pass:String) {
        self.name = name
        self.pass = pass
        players = [Player?](repeating: nil, count: 4)
        prevTime = Date()
        slothGroup = SlothGroup()
    }
    
    func copyFrom (room: RoomGroup) {
        name = room.name
        pass = room.pass
        players = room.players
        slothGroup = room.slothGroup
    }
    
    func getPlayer (withUser: String) -> Player? {
        for maybePlayer in players {
            if let player = maybePlayer {
                if player.user.elementsEqual(withUser) {
                    return player
                }
            }
        }
        return nil
    }
    
    func getSlothy (withName: String) -> Sloth? {
        return slothGroup.getSlothy(withName: withName)
    }
    
    func getSlothy (index: Int) -> Sloth? {
        return slothGroup.getSlothy(index: index)
    }
    
    func forSlothy (fun: (Sloth?) -> ()) {
        slothGroup.forSlothy(fun: fun)
    }
    
    //dado um jogador, um nome, um sexo, e a posicao da preguicinha (index), cria o objeto correspondente e coloca as devidas referencias
    func createSloth (player: Player, name: String, sex: Sex, index: Int) -> Bool {
        if (slothGroup.hasSlothy(withName: name)) {
            return false
        }
        let slothy = Sloth(name: name, sex: sex)
        slothy.player = player
        player.slothy = slothy
        players[index] = player
        slothGroup.addSloth(sloth: slothy, i: index)
        return true
    }
}
