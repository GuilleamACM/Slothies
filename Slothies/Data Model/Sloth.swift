//
//  Sloth.swift
//  Slothies
//
//  Created by Lucas Miranda Lin on 13/05/19.
//  Copyright © 2019 Slothies Inc. All rights reserved.
//

import UIKit

enum Sex {
    case male
    case female
}

enum State {
    case idle
    case sleeping
    case eating
    case exercising
    case sad
    case dead
}

enum AutopsyResult {
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
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    //key values for sleep and hunger
    static let statusMaxValue: Double = secondsPerDay * 2
    static let statusMinValue: Double = 0
    static let statusInitValue: Double = Sloth.statusMaxValue
    static let hungerFeedingValue: Double = secondsPerDay
    
    //nome, sexo
    let name: String
    let sex: Sex
    
    //fome, sono
    var hunger, sleep: Double
    
    var sloth: Double {
        return slothometer!.individualValues[self]!
    }
    
    //jogador associado
    var player: Player?
    
    //preguicometro
    var slothometer: Slothometer?
    
    //estado
    var state: State
    
    init(name: String, sex: Sex) {
        self.name = name
        self.sex = sex
        hunger = Sloth.statusInitValue
        sleep = Sloth.statusInitValue
        state = .idle
    }
    
    func update (prevTime: Date, currTime: Date, info: (steps: Double, distance: Double)) {
        if let slothometer = slothometer {
            //pass information to slothometer
            slothometer.updateSpecificValue(slothy: self, info: info)
        }
        
        let elapsed = Double(currTime.timeIntervalSince(prevTime))

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
