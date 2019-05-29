//
//  Player.swift
//  Slothies
//
//  Created by Lucas Miranda Lin on 13/05/19.
//  Copyright © 2019 Slothies Inc. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Player: Equatable {
    //deve conter informacoes e metodos relacionados a ao jogador
    
    //estes comentarios foram escritos sem muito pensamento
    //se achar melhor, sinta-se disposto a ignora-los
    
    //identificador unico ao jogador. não é definitivo
    let user: String
    
    var lastUpdate: Date
    
    //preguicinha
    var slothy: Sloth?
    //coins for the player
    var coins: Int
    
    //algum valor anterior de exercicio (i.e. numero previo de passos)
    //use para atualizar preguiçometro
    //ainda não olhamos healthkit: não sabemos se é necessário, ou de que dado se trata
    var previousHealthStatus: Int
    
    init(user: String) {
        self.user = user
        self.previousHealthStatus = 0
        self.coins = 0
        self.lastUpdate = Date()
    }
    
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.user == rhs.user
    }
    
    func setSloth(sloth: Sloth) {
        self.slothy = sloth
    }
    
    let runToStepLock = NSCondition()
    let stepToFinishLock = NSCondition()
    
    func getHealthData (_ currentTime: Date) -> (steps: Double, distance: Double)? {
        var gotDistance = false
        var gotSteps = false
        var info: (steps: Double, distance: Double) = (steps: 0, distance: 0)
        
        HealthHandler.singleton.getWalkingRunningDistance(startDate: lastUpdate, endDate: currentTime){ (value,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }else if let value = value {
                gotDistance = true
                info.distance = value
            }
            self.runToStepLock.signal()
        }
        runToStepLock.wait(until: Date().addingTimeInterval(0.5))
        HealthHandler.singleton.getStepsCount(startDate: lastUpdate, endDate: currentTime){ (value,error) in
            if let error = error{
                print(error.localizedDescription)
                return
            }else if let value = value{
                gotSteps = true
                info.steps = value
            }
            self.stepToFinishLock.signal()
        }
        stepToFinishLock.wait(until: Date().addingTimeInterval(0.5))
        if gotDistance && gotSteps {
            lastUpdate = currentTime
            return info
        } else {
            return nil
        }
    }
    
    func awardCoins(coins: Int){
        self.coins += coins
    }
}
