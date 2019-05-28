//
//  GameDataUpdatable.swift
//  Slothies
//
//  Created by Lucas Miranda Lin on 28/05/19.
//  Copyright © 2019 Slothies Inc. All rights reserved.
//

import Foundation

protocol GameDataUpdateable {
    func completionUpdateInterface(room: RoomGroup?, err: String?) -> ()
}
