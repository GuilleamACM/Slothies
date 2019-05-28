//
//  NetworkHandler.swift
//  Slothies
//
//  Created by cub on 15/05/19.
//  Copyright © 2019 Slothies Inc. All rights reserved.
//

import UIKit
import Firebase

var accounts: [Player] = []
var rooms: [RoomGroup] = []

class NetworkHandler {
    //classe que deve conter qualquer método para o qual espera-se acessar a rede
    static let singleton: NetworkHandler = NetworkHandler()
    let db = Firestore.firestore()
    
    private func writeRoom (room: RoomGroup) {
        db.collection("rooms").document(room.name).setData(room.dictionary)
    }
    
    private func createPlayerToRoomLink (roomName: String, user:String) {
        db.collection("players").document(user).setData(["roomName":roomName])
    }
    
    private func getRoomName (forUser: String) -> String? {
        let userRef = db.collection("players").document(forUser)
        var returnStr: String? = nil
        userRef.getDocument { (doc, err) in
            if let doc = doc, doc.exists {
                let str = doc.data()!["roomName"] as! String
                returnStr = str
            }
        }
        return returnStr
    }
    
    func fetchRoom(code: String, pass: String) -> RoomGroup? {
        var returnRoom: RoomGroup? = nil
        db.collection("rooms").document(code).getDocument { (doc, err) in
            if let doc = doc {
                let tempRoom = RoomGroup(dictionary: doc.data()!)!
                if tempRoom.pass == pass {
                    returnRoom = tempRoom
                }
            }
        }
        
        return returnRoom
    }
    
    func requestCreateSlothAndLinkPlayer (room: RoomGroup, player: Player, name: String, sex: Sex, index: Int,
                                          completion: @escaping (_ result: (room: RoomGroup, player: Player)?, _ error : String?) -> ()) {
        let roomRef = db.collection("rooms").document(room.name)
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let roomDocument : DocumentSnapshot
            do {
                try roomDocument = transaction.getDocument(roomRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                completion (nil, fetchError.localizedDescription)
                return nil
            }
            
            guard let roomData = roomDocument.data(),
                let roomDoc = RoomGroup(dictionary: roomData) else {
                    completion(nil, "failed to retreive room from document \(roomDocument)")
                    return nil
            }
            
            if let errMessage = roomDoc.updateWithPlayerHealthInfo(player) {
                completion(nil, errMessage)
                return nil
            }
            
            if !roomDoc.createSloth(player: player, name: name, sex: sex, index: index) {
                completion(nil, "slothy name already exists")
                return nil
            }
            
            transaction.setData(roomDoc.dictionary, forDocument: roomRef)
            self.createPlayerToRoomLink(roomName: roomDoc.name, user: player.user)
            completion((room: roomDoc, player: roomDoc.getPlayer(withUser: player.user)!), nil)
            return nil
        }) { (obj, err) in
            if let err = err {
                print("transaction failed: \(err)")
            }
        }
    }
    
    func requestFeedSloth (room: RoomGroup, slothy: Sloth, completion: @escaping (_ result: (room: RoomGroup, slothy: Sloth)?, _ error : String?) -> ()) {
        let roomRef = db.collection("rooms").document(room.name)
        
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let roomDocument : DocumentSnapshot
            do {
                try roomDocument = transaction.getDocument(roomRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                completion (nil, fetchError.localizedDescription)
                return nil
            }
            
            guard let roomData = roomDocument.data(),
                let roomDoc = RoomGroup(dictionary: roomData) else {
                    completion(nil, "failed to retreive room from document \(roomDocument)")
                    return nil
            }
            
            guard let slothy = roomDoc.getSlothy(withName: slothy.name),
                slothy.checkCanFeed() else {
                    completion(nil, "could not feed slothy")
                    return nil
            }
            slothy.feed()
            transaction.setData(roomDoc.dictionary, forDocument: roomRef)
            completion((room: roomDoc, slothy: slothy),nil)
            
            return nil
        }) { (obj, err) in
            if let err = err {
                print("transaction failed: \(err)")
            }
        }
    }
        
    
    
    func requestSleepSloth (room: RoomGroup, slothy: Sloth) -> (RoomGroup, Sloth)? {
        if let slothy = room.getSlothy(withName: slothy.name){
            if slothy.checkCanSleep() {
                slothy.putToSleep()
                return (room, slothy)
            }
        }
        return nil
    }
    
    func requestUpdate (room: RoomGroup, player: Player,
                        completion: @escaping (_ result: (room: RoomGroup, player: Player)?, _ error : String?) -> ()) {
        let roomRef = db.collection("rooms").document(room.name)
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let roomDocument : DocumentSnapshot
            do {
                try roomDocument = transaction.getDocument(roomRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                completion (nil, fetchError.localizedDescription)
                return nil
            }
            
            guard let roomData = roomDocument.data(),
                let roomDoc = RoomGroup(dictionary: roomData) else {
                    completion(nil, "failed to retreive room from document \(roomDocument)")
                    return nil
            }
            
            if let errMessage = roomDoc.updateWithPlayerHealthInfo(player) {
                completion(nil, errMessage)
                return nil
            }
            
            transaction.setData(roomDoc.dictionary, forDocument: roomRef)
            completion((room: roomDoc, player: roomDoc.getPlayer(withUser: player.user)!), nil)
            return nil
        }) { (obj, err) in
            if let err = err {
                print("transaction failed: \(err)")
            }
        }
    }
    
    let runRoomInit = true
    
    init() {
        print("calling NetworkHandler INIT")
        
        if runRoomInit {
            let room = RoomGroup(name: "room", pass: "pass")
            writeRoom(room: room)
        }
        
        /*
        let p1 = Player(username: "player1" , pass: "p1")
        accounts.append(p1)
        
        let p2 = Player(username: "player2" , pass: "p2")
        let _ = tempRoom.createSloth(player: p2, name: "Atashi", sex: .female
            , index: 1)
        accounts.append(p2)
        
        let p3 = Player(username: "player3" , pass: "p3")
        let _ = tempRoom.createSloth(player: p3, name: "Lolin", sex: .male
            , index: 2)
        accounts.append(p3)
         */
    }
}
