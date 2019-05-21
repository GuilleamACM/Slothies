//
//  GroupRoom.swift
//  Slothies
//
//  Created by Lucas Miranda Lin on 13/05/19.
//  Copyright © 2019 Slothies Inc. All rights reserved.
//

import UIKit

class RoomGroup {
    //deve conter informacoes e metodos relacionados a sala, aos jogadores dela, e talvez as preguicas
    
    //estes comentarios foram escritos sem muito pensamento
    //se achar melhor, sinta-se disposto a ignora-los
    
    //nome e senha da sala
    let name: String
    let pass: String
    
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
    
    func getPlayer (withName: String) -> Player? {
        for maybePlayer in players {
            if let player = maybePlayer {
                if player.identifier.elementsEqual(withName) {
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
    
    func updateWithPlayerHealthInfo (player: Player, info: (steps: Double, distance: Double), lastDate: Date) {
        var playerToUpdate: Player? = nil
        for play in players {
            if let play = play {
                if play.identifier.elementsEqual(player.identifier) {
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
