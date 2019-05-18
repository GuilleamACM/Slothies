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
    var players: [Player]
    
    //data de último acesso ao aplicativo, use para atualizar preguiçometro
    var prevTime: Date
    
    //referencia ao grupo de preguiças
    var slothGroup: SlothGroup
    
    init (na:String, pa:String) {
        name = na
        pass = pa
        players = []
        prevTime = Date()
        slothGroup = SlothGroup()
    }
    
    //update to call upon opening the app/joining the room
    func longUpdate (currentTime: Date) {
        let timeElapsed = Int(currentTime.timeIntervalSince(prevTime))
        
        slothGroup.longUpdate(prevTime: prevTime, currTime: currentTime)
        for player in players {
            player.longUpdate(prevTime: prevTime, currTime: currentTime)
        }
        prevTime = currentTime
    }
    
    //update to call while the app is running
    func update (currentTime: Date) {
        
        prevTime = currentTime
    }
    
    //dado um jogador, um nome, um sexo, e a posicao da preguicinha (index), cria o objeto correspondente e coloca as devidas referencias
    func createSloth (player: Player, name: String, sex: sex, index: Int) {
        var slothy = Sloth(na: name, se: sex)
        slothy.player = player
        player.slothy = slothy
        players[index] = player
        slothGroup.addSloth(sloth: slothy, i: index)
    }
}