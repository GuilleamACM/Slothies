//
//  Slothometer.swift
//  Slothies
//
//  Created by Lucas Miranda Lin on 13/05/19.
//  Copyright © 2019 Slothies Inc. All rights reserved.
//

import UIKit

class Slothometer {
    //deve incluir informacoes e metodos referentes ao funcionamento de um preguicometro
    
    //estes comentarios foram escritos sem muito pensamento
    //se achar melhor, sinta-se disposto a ignora-los
    
    //key values for sloth
    static let maxValue: Double = secondsPerDay * daysPerWeek
    static let minValue: Double = 0
    static let initValue: Double = secondsPerDay * (daysPerWeek - 1)
    
    //current total slothometer
    var totalValue: Double
    
    //values for each sloth
    var individualValues: Dictionary<Sloth, Double>
    
    init () {
        totalValue = Slothometer.initValue
        individualValues = Dictionary<Sloth, Double>()
    }
    
    //currently, min of all sloth values
    func updateTotalValue () {
        var accu = Slothometer.maxValue
        individualValues.keys.forEach {
            accu = min(accu, individualValues[$0]!)
        }
        if accu <= Slothometer.minValue {
            totalValue = Slothometer.minValue
            //gameOver()
        } else {
            totalValue = accu
        }
    }
    
    //place slothy into dictionary with initial value
    func addSloth (slothy: Sloth) {
        individualValues[slothy] = Slothometer.initValue
        updateTotalValue()
    }
    
    private func addSpecificValue(slothy: Sloth, val: Double) {
        var result = individualValues[slothy]! + val
        result = min(result, Slothometer.maxValue)
        updateTotalValue()
    }
    
    //subtract seconds passed from values
    func update (prevTime: Date, currTime: Date) {
        let elapsed = Double(currTime.timeIntervalSince(prevTime))
        individualValues.keys.forEach {
            addSpecificValue(slothy: $0, val: -elapsed)
        }
        updateTotalValue()
    }
    
    //check workout information, sum appropriate number into values
    func updateSpecificValue (slothy: Sloth, info: (steps: Double,distance: Double)) {
        //TODO: check workout information to see if everything is okay
        let stepsPercent = info.steps/stepsHealthPerDay
        let slothmeters = stepsPercent*secondsPerDay
        
        addSpecificValue(slothy: slothy, val: slothmeters)
        //TODO: better define sloth reward for working out
        updateTotalValue()
    }
}
