//
//  SlothsGroup.swift
//  Slothies
//
//  Created by Lucas Miranda Lin on 13/05/19.
//  Copyright © 2019 Slothies Inc. All rights reserved.
//

import UIKit

class SlothGroup {
    //deve conter informacoes e metodos relacionados as preguicas enquanto grupo (i.e. preguicometro, recursos totais do grupo, referencias a cada preguica do grupo)
    
    //estes comentarios foram escritos sem muito pensamento
    //se achar melhor, sinta-se disposto a ignora-los
    
    //list of sloths
    var slothies: [Sloth?]
    
    //slothometer
    var slothometer: Slothometer
    
    //groupwide resources
    var food: Int
    var money: Int
    
    init() {
        slothies = [Sloth?](repeating: nil, count: 4)
        food = 100
        money = 100
        slothometer = Slothometer()
    }
    
    func getSlothy (index: Int) -> Sloth? {
        return slothies[index]
    }
    
    func forSlothy (fun: (Sloth?) -> ()) {
        for sloth in slothies {
            fun(sloth)
        }
    }
    
    //add a sloth to the group. associate slothometer and slothy
    func addSloth(sloth: Sloth, i: Int) {
        sloth.slothometer = slothometer
        slothies[i] = sloth
        slothometer.addSloth(slothy: sloth)
    }
    
    //pass to slothometer
    func update (prevTime: Date, currTime: Date) {
        slothometer.update(prevTime: prevTime, currTime: currTime)
    }
    
    func hasSloth (withName: String) -> Bool {
        var has = false
        slothies.forEach({
            if let slothy = $0 {
                has = has || slothy.name.elementsEqual(withName)
            }
        })
        return has
    }
}
