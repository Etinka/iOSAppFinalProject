//
//  FirebaseModel.swift
//  iOSFinalProject
//
//  Created by Eti Negev on 05/12/2018.
//  Copyright © 2018 Eti Negev. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseFirestore

class FirebaseModel{
    let db: Firestore
    let propertiesCollection:CollectionReference
    var listener: ListenerRegistration?
    
    init() {
        FirebaseApp.configure()
        db = Firestore.firestore()
        propertiesCollection = db.collection("properties")
    }
    
    func stop(){
        print("Stopping Firebase")
        listener?.remove()
    }
    
    func getAllProperties(callback: @escaping ([Property]) -> Void){
       listener = propertiesCollection.addSnapshotListener({ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var data = [Property]()

                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    data.append(Property(data: document.data()))
                }
                
                callback(data)
            }
        })
    }
}
