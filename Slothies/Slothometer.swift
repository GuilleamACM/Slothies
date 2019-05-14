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
    
    //max, min value of slothometer bar. temporary values
    static let maxValue: Int = 1000
    static let minValue: Int = 0
    
    //current total slothometer
    var totalValue: Int
    
    //values for each sloth
    var individualValues: Dictionary<Sloth, Int>
    
    init () {
        totalValue = 700
        individualValues = Dictionary<Sloth, Int>()
    }
    
    func addSloth (slothy: Sloth) {
        individualValues[slothy] = 100
    }
    
    func updateValue () {
        //stub. update slothometer values
    }
}
