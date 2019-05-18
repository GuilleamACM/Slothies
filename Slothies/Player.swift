//
//  Player.swift
//  Slothies
//
//  Created by Lucas Miranda Lin on 13/05/19.
//  Copyright © 2019 Slothies Inc. All rights reserved.
//

import UIKit

class Player {
    //deve conter informacoes e metodos relacionados a ao jogador
    
    //estes comentarios foram escritos sem muito pensamento
    //se achar melhor, sinta-se disposto a ignora-los
    
    //identificador unico ao jogador. não é definitivo
    let identifier: String
    let password: String
    
    //preguicinha
    var slothy: Sloth?
    
    //algum valor anterior de exercicio (i.e. numero previo de passos)
    //use para atualizar preguiçometro
    //ainda não olhamos healthkit: não sabemos se é necessário, ou de que dado se trata
    var previousHealthStatus: Int
    
    
    init(username: String, pass: String) {
        self.identifier = username
        self.password = pass
        self.previousHealthStatus = 0
    }
    
    func setSloth(sloth: Sloth) {
        self.slothy = sloth
    }
    
    //fetch user's activity since previous access and update sloth with it
    func update (prevTime: Date, currTime: Date) {
        let info = self //TODO: fetch from HealthHandler
        
        if let slothy = slothy {
            slothy.update(prevTime: prevTime, currTime: currTime, info: info)
        }
    }
}
