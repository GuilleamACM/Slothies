//
//  Sloth.swift
//  Slothies
//
//  Created by Lucas Miranda Lin on 13/05/19.
//  Copyright © 2019 Slothies Inc. All rights reserved.
//

import UIKit

enum sex {
    case male
    case female
}

enum state {
    case idle
    case sleepy
    case hungry
    case dying
}

class Sloth : Hashable {
    //classe representante de uma preguicinha. deve incluir informacoes e metodos referentes a preguica enquanto individuo (e provavelmente uma referencia ao Player a quem pertence a preguica?)
    
    //estes comentarios foram escritos sem muito pensamento
    //se achar melhor, sinta-se disposto a ignora-los
    
    //funcoes necessarias para implementar hashable
    static func == (lhs: Sloth, rhs: Sloth) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    var hashValue: Int {
        return name.hashValue
    }
    
    //nome, sexo
    let name: String
    let sex: sex
    
    //fome, sono
    var hunger, sleep: Int
    
    //jogador associado
    var player: Player?
    
    //estado
    var state: state
    
    init(na: String, se: sex) {
        name = na
        sex = se
        hunger = 100
        sleep = 100
        state = .idle
    }
}
