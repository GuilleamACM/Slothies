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
    case sleeping
    case sleepy
    case eating
    case hungry
    case exercising
    case dying
}

enum autopsyResult {
    case hunger
    case noSleep
    case sloth
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
    
    //key values for sleep and hunger
    static let statusMaxValue = secondsPerDay * 2
    static let statusMinValue = 0
    static let statusInitValue = Sloth.statusMaxValue
    static let hungerFeedingValue = secondsPerDay
    
    //nome, sexo
    let name: String
    let sex: sex
    
    //fome, sono
    var hunger, sleep: Int
    
    //jogador associado
    var player: Player?
    
    //preguicometro
    var slothometer: Slothometer?
    
    //estado
    var state: state
    
    init(na: String, se: sex) {
        name = na
        sex = se
        hunger = Sloth.statusInitValue
        sleep = Sloth.statusInitValue
        state = .idle
    }
    
    func longUpdate (prevTime: Date, currTime: Date, info: Any) {
        if let slothometer = slothometer {
            //pass information to slothometer
            slothometer.longUpdateSpecificValue(slothy: self, info: info)
        }
        
        let elapsed = Int(currTime.timeIntervalSince(prevTime))

        //
        switch state {
        case .sleeping:
            sleep += elapsed
            hunger -= elapsed
            break
        default:
            sleep -= elapsed
            hunger -= elapsed
        }
    }
}
