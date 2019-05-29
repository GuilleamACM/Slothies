//
//  Sloth.swift
//  Slothies
//
//  Created by Lucas Miranda Lin on 13/05/19.
//  Copyright © 2019 Slothies Inc. All rights reserved.
//

import UIKit

enum Sex : String {
    case male = "Male"
    case female = "Female"
}

enum State: String {
    case idle = "idle"
    case sleeping = "sleeping"
    case eating = "eating"
    case exercising = "exercising"
    case sad = "sad"
    case dead = "dead"
}

enum AutopsyResult:String {
    case hunger = "hunger"
    case noSleep = "noSleep"
    case sloth = "sloth"
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
    static let feedingCooldown: Double = secondsPerMinute * 5
    static let sleepingCooldown: Double = secondsPerMinute * 120
    static let sleepingMultiplier: Double = 4
    
    //nome, sexo
    let name: String
    let sex: Sex
    
    //fome, sono
    var hunger, sleep: Double
    //ultima alimentacao e soneca
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
    }
    
    func checkCanSleep () -> Bool {
        if let slept = lastSlept {
            return Sloth.sleepingCooldown < Date().timeIntervalSince(slept)
        }
        return true
    }
    
    func putToSleep () {
        lastSlept = Date()
        state = .sleeping
    }
    
    func checkCanFeed () -> Bool {
        if let fed = lastFed {
            return Sloth.feedingCooldown < Date().timeIntervalSince(fed)
        }
        return true
    }
    
    func feed () {
        lastFed = Date()
        hunger += Sloth.hungerFeedingValue
        hunger = min(Sloth.statusMaxValue, hunger)
        state = .eating
    }
}
