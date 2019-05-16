//
//  Slothometer.swift
//  Slothies
//
//  Created by Lucas Miranda Lin on 13/05/19.
//  Copyright © 2019 Slothies Inc. All rights reserved.
//

import UIKit

let secondsPerDay = 86400
let daysPerWeek = 7

class Slothometer {
    //deve incluir informacoes e metodos referentes ao funcionamento de um preguicometro
    
    //estes comentarios foram escritos sem muito pensamento
    //se achar melhor, sinta-se disposto a ignora-los
    
    //max, min value of slothometer bar. temporary values
    static let maxValue: Int = secondsPerDay * daysPerWeek
    static let minValue: Int = 0
    
    //current total slothometer
    var totalValue: Int
    
    //values for each sloth
    var individualValues: Dictionary<Sloth, Int>
    
    init () {
        totalValue = secondsPerDay * (daysPerWeek - 1)
        individualValues = Dictionary<Sloth, Int>()
    }
    
    //place slothy into dictionary with initial value
    func addSloth (slothy: Sloth) {
        individualValues[slothy] = secondsPerDay * (daysPerWeek - 1)
    }
    
    //subtract seconds passed from values
    func longUpdate (prevTime: Date, currTime: Date) {
        let elapsed = Int(currTime.timeIntervalSince(prevTime))
        individualValues.keys.forEach {
            individualValues[$0] = individualValues[$0]! - elapsed
        }
        updateTotalValue()
    }
    
    //check workout information, sum appropriate number into values
    func longUpdateSpecificValue (slothy: Sloth, info: Any) {
        //TODO: check workout information to see if everything is okay
        individualValues[slothy] = individualValues[slothy]! + 2 * secondsPerDay
        updateTotalValue()
    }
    
    //currently, average all sloth values
    func updateTotalValue () {
        var accu = 0
        individualValues.keys.forEach {
            accu += individualValues[$0]!
        }
        totalValue = accu / individualValues.keys.count
    }
}
