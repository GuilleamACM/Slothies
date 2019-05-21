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
    
    var lastUpdate: Date
    
    //preguicinha
    var slothy: Sloth?
    //coins for the player
    var coins: Int
    
    //algum valor anterior de exercicio (i.e. numero previo de passos)
    //use para atualizar preguiçometro
    //ainda não olhamos healthkit: não sabemos se é necessário, ou de que dado se trata
    var previousHealthStatus: Int
    
    
    init(username: String, pass: String) {
        self.identifier = username
        self.password = pass
        self.previousHealthStatus = 0
        self.coins = 0
        self.lastUpdate = Date()
    }
    
    func setSloth(sloth: Sloth) {
        self.slothy = sloth
    }
    
    func sendDataToServer () {
        
    }
    
    func getHealthData () -> (Double, Double)? {
        var gotDistance = false
        var gotSteps = false
        var info: (steps: Double, distance: Double) = (steps: 0, distance: 0)
        let now = Date()
        
        HealthHandler.singleton.getWalkingRunningDistance(startDate: lastUpdate, endDate: now){ (value,error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }else if let value = value {
                DispatchQueue.main.async {
                    gotDistance = true
                    info.distance = value
                }
            }
        }
        
        HealthHandler.singleton.getStepsCount(startDate: lastUpdate, endDate: now){ (value,error) in
            if let error = error{
                print(error.localizedDescription)
                return
            }else if let value = value{
                DispatchQueue.main.async {
                    gotSteps = true
                    info.steps = value
                }
            }
        }
        
        if gotDistance && gotSteps {
            lastUpdate = now
            return info
        } else {
            return nil
        }
    }
    
    //fetch user's activity since previous access and update sloth with it
    func update (date: Date, info: (steps: Double, distance: Double)) {
        if let slothy = slothy {
            slothy.updateWithInfo(currTime: date, info: info)
        }
        lastUpdate = date
    }
    
    func awardCoins(coins: Int){
        self.coins += coins
    }
}
