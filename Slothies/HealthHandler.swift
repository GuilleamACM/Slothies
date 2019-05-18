//
//  HealthHandler.swift
//  Slothies
//
//  Created by Henrique Andrade Mariz  on 18/05/19.
//  Copyright © 2019 Slothies Inc. All rights reserved.
//

import Foundation
import HealthKit

class HealthHandler{
    

    private func authorizeHealthKit() {
        
        HealthKitSetupAssistant.authorizeHealthKit { (authorized, error) in
            
            guard authorized else {
                
                let baseMessage = "HealthKit Authorization Failed"
                
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseMessage)
                }
                
                return
            }
            
            print("HealthKit Successfully Authorized.")
        }
        
    }
    
    func getWalkingRunningDistance(startDate: Date, endDate: Date, completion: @escaping (Double, Error?) -> () ){
        
        let healthStore = HKHealthStore()
        
        do{
            guard let type = HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning) else {
                fatalError("Something went wrong retriebing quantity type distanceWalkingRunning")
            }
            
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
            
            let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: [.cumulativeSum]) { (query, statistics, error) in
                var value: Double = 0
                
                if error != nil {
                    print("something went wrong")
                } else if let quantity = statistics?.sumQuantity() {
                    value = quantity.doubleValue(for: HKUnit.meter())
                }
                DispatchQueue.main.async {
                    completion(value, error)
                }
            }
            healthStore.execute(query)
        }
    }
    
    func getStepsCount(startDate: Date, endDate: Date, completion: @escaping (Double, Error?) -> () ){
        
        let healthStore = HKHealthStore()
        
        do{
            guard let type = HKSampleType.quantityType(forIdentifier: .stepCount) else {
                fatalError("Something went wrong retriebing quantity type distanceWalkingRunning")
            }
            
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
            
            let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: [.cumulativeSum]) { (query, statistics, error) in
                var value: Double = 0
                
                if error != nil {
                    print("something went wrong")
                } else if let quantity = statistics?.sumQuantity() {
                    value = quantity.doubleValue(for: HKUnit.count())
                }
                DispatchQueue.main.async {
                    completion(value, error)
                }
            }
            healthStore.execute(query)
        }
    }
    
    
}
