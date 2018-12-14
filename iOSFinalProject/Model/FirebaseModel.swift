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
    var handle: AuthStateDidChangeListenerHandle?
    
    init() {
        FirebaseApp.configure()
        db = Firestore.firestore()
        propertiesCollection = db.collection("properties")
//        logout()
    }
    
    func start(){
        startAuth()
    }
    
    func stop(){
        print("Stopping Firebase")
        listener?.remove()
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    func startAuth(){
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.sendLoggedInStatusMessage(isLoggedIn: user != nil)
        }
    }
    
    func registerUser(email: String, password: String){
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if (authResult?.user) != nil  {
                self.sendLoggedInStatusMessage(isLoggedIn: true)
            }
            else  {
                self.sendLoggedInStatusMessage(isLoggedIn: false, error: error)
            }
        }
    }
    
    func signInUser(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            self.sendLoggedInStatusMessage(isLoggedIn: error == nil, error: error)
        }
    }
    
    func logout(){
        do {
            try Auth.auth().signOut()
        }
        catch  {
            print("logout error")
        }
    }
    
    func getAllProperties(callback: @escaping ([Property]) -> Void){
        listener = propertiesCollection.addSnapshotListener({ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                //Todo --> add error handling in the viewcontroller
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
    
    private func sendLoggedInStatusMessage(isLoggedIn: Bool, error: Error? = nil){
        NotificationService.userLoggedInNotification.notify(data: UserLoggedInData(_isLoggedIn: isLoggedIn, _error: error))
    }
}
