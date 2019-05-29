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
    static var listenerDispatch: GameDataUpdateable? = nil
    
    func initiateListening (room: RoomGroup) {
        db.collection("rooms").document(room.name).addSnapshotListener { (doc, err) in
            if let dispatch = NetworkHandler.listenerDispatch {
                if let doc = doc {
                    if let data = doc.data() {
                        let roomDoc = RoomGroup(dictionary: data)!
                        DispatchQueue.main.async {
                            dispatch.completionUpdateInterface(room: roomDoc, err: nil)
                        }
                    }
                }
            }
        }
    }
    
    private func writeRoom (room: RoomGroup) {
        db.collection("rooms").document(room.name).setData(room.dictionary)
    }
    
    private func createPlayerToRoomLink (roomName: String, user:String) {
        db.collection("players").document(user).setData(["roomName":roomName])
    }
    
    func fetchRoom (forUser: String, completion: @escaping (RoomGroup?, String?) -> ()) {
        let userRef = db.collection("players").document(forUser)
        userRef.getDocument { (doc, err) in
            if let doc = doc, doc.exists {
                let roomName = doc.data()!["roomName"] as! String
                let roomRef = self.db.collection("rooms").document(roomName)
                roomRef.getDocument(completion: { (doc, err) in
                    if let doc = doc, doc.exists {
                        if let room = RoomGroup(dictionary: doc.data()!) {
                            completion(room, nil)
                        } else {
                            completion(nil, "failed initialization from dictionary")
                        }
                    } else {
                        completion(nil, err!.localizedDescription)
                    }
                })
            } else {
                completion(nil, "new player")
            }
        }
    }
    
    func fetchRoom(code: String, pass: String, completion: @escaping (_ room: RoomGroup?, _ error : String?) -> ()) {
        db.collection("rooms").document(code).getDocument { (doc, err) in
            if let doc = doc {
                let room = RoomGroup(dictionary: doc.data()!)
                if let room = room, room.pass == pass {
                    completion(room, nil)
                } else {
                    completion(room, "incorrect password or failed initialization from dictionary")
                }
            } else {
                completion (nil, err!.localizedDescription)
            }
        }
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
        
    
    
    func requestSleepSloth (room: RoomGroup, slothy: Sloth, completion: @escaping (_ result: (room: RoomGroup, slothy: Sloth)?, _ error : String?) -> ()) {
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
            
            guard let slothy = room.getSlothy(withName: slothy.name),
                slothy.checkCanSleep() else{
                completion(nil, "slothy could not sleep")
                return nil
            }
            
            slothy.putToSleep()
            transaction.setData(roomDoc.dictionary, forDocument: roomRef)
            completion((room: roomDoc, slothy: slothy),nil)
            
            return nil
            
        }) { (obj, err) in
            if let err = err {
                print("transaction failed: \(err)")
            }
        }
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
    
     func wipeRoom(room: RoomGroup, completion: @escaping (_ room: RoomGroup?, _ error : String?) -> ()) {
        //reset players
        let players = room.players
        for player in players{
            if let player = player{
                db.collection("players").document(player.user).delete() { err in
                    if let err = err{
                        print("Error removing socument: \(err)")
                    }else{
                        print("Document sucessfully removed!")
                    }
                }
            }
        }
        
        //reset room
        let roomNew = RoomGroup(name:room.name,pass:room.pass)
        self.writeRoom(room: roomNew)
        Thread.sleep(forTimeInterval: 10)
        crash("reset app")
    }
    
    func jumpToPastDate(room: RoomGroup, timeInterval:TimeInterval, completion: @escaping (_ room: RoomGroup?, _ error : String?) -> ()) {
        
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
            
            roomDoc.prevTime = roomDoc.prevTime.addingTimeInterval(-timeInterval)
            roomDoc.timePassageUpdate(Date())
            transaction.setData(roomDoc.dictionary, forDocument: roomRef)
            completion(roomDoc, nil)
            return nil
        }) { (obj, err) in
            if let err = err {
                print("transaction failed: \(err)")
            }
        }
    }
    
    func fakeExercise(room: RoomGroup, player: Player, fakeSteps: Double, fakeDistance: Double, completion: @escaping (_ room: RoomGroup?, _ error : String?) -> ()) {
        
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
            
            if let err = roomDoc.updateWithPretendData(player, steps: fakeSteps, distance: fakeDistance){
                completion(nil,err)
                return nil
            }
            transaction.setData(roomDoc.dictionary, forDocument: roomRef)
            completion(roomDoc, nil)
            return nil
        }) { (obj, err) in
            if let err = err {
                print("transaction failed: \(err)")
            }
        }
        
    }
    
    let runRoomInit = false
    let staticPlayers = false
    
    init() {
        print("calling NetworkHandler INIT")
        
        if runRoomInit {
            let room = RoomGroup(name: "room", pass: "pass")
            writeRoom(room: room)
            let room2 = RoomGroup(name: "room2", pass: "pass")
            writeRoom(room: room2)
            let room3 = RoomGroup(name: "room3", pass: "pass")
            writeRoom(room: room3)
            let room4 = RoomGroup(name: "room4", pass: "pass")
            writeRoom(room: room4)
            let room5 = RoomGroup(name: "room5", pass: "pass")
            writeRoom(room: room5)
            
            if staticPlayers {
                let p2 = Player(user: "lim")
                requestCreateSlothAndLinkPlayer(room: room, player: p2, name: "lolin", sex: .female, index: 1, completion: {_,_ in })
                
                let p3 = Player(user: "riq")
                requestCreateSlothAndLinkPlayer(room: room, player: p3, name: "riqdog", sex: .female, index: 2, completion: {_,_ in })
            }
            
            let roomTeste = RoomGroup(name: "teste", pass: "teste")
            writeRoom(room: roomTeste)
            
            let roomMeme = RoomGroup(name: "YUH", pass: "DAB")
            writeRoom(room: roomMeme)
            
            Thread.sleep(forTimeInterval: 30)
        }
        
        /*
        let p1 = Player(username: "player1" , pass: "p1")
        accounts.append(p1)
        accounts.append(p3)
         */
    }
}
