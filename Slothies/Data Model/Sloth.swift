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
    static let statusInitValue: Double = Sloth.statusMaxValue * 8 / 10
    static let hungerFeedingValue: Double = secondsPerDay / 2
    
    //nome, sexo
    let name: String
    let sex: Sex
    
    //fome, sono
    var hunger, sleep: Double
    //ultima alimentacao e soneca
    var lastUpdate: Date
    var lastFed, lastSlept: Date?
    
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
        lastUpdate = Date()
    }
    
    func checkCanFeed () -> Bool {
        if let fed = lastFed {
            return 5 * secondsPerMinute < Date().timeIntervalSince(fed)
        }
        return true
    }
    
    func feed () {
        hunger += Sloth.hungerFeedingValue
        state = .eating
    }
    
    func updateWithInfo (currTime: Date, info: (steps: Double, distance: Double)) {
        if let slothometer = slothometer {
            slothometer.updateSpecificValue(slothy: self, info: info)
        }
        
        update(currTime)
    }
    
    func update(_ currTime: Date) {
        let elapsed = Double(currTime.timeIntervalSince(lastUpdate))
        lastUpdate = Date()
        
        switch state {
        case .sleeping:
            sleep += elapsed
            hunger -= elapsed
            break
        case .eating:
            sleep -= elapsed
            hunger -= elapsed
            if 5 * secondsPerMinute < currTime.timeIntervalSince(lastFed!) {
                state = .idle
            }
            break
        default:
            sleep -= elapsed
            hunger -= elapsed
            break
        }
    }
}
