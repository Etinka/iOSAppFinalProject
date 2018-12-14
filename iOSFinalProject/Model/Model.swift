//
//  Model.swift
//  iOSFinalProject
//
//  Created by Eti Negev on 05/12/2018.
//  Copyright © 2018 Eti Negev. All rights reserved.
//

import Foundation

class Model{
    
    static let instance:Model = Model()
    
    var modelFirebase = FirebaseModel()
    
    func start(){
        modelFirebase.start()
    }
    
    func stop(){
        modelFirebase.stop()
    }
    
    func registerUser(email: String, password: String){
        modelFirebase.registerUser(email: email, password: password)
    }
    
    func signInUser(email: String, password: String){
        modelFirebase.signInUser(email: email, password: password)
    }
    
    func logout(){
        modelFirebase.logout()
    }
    
    func getAllProperties(callback: @escaping ([Property]) -> Void){
        modelFirebase.getAllProperties(callback: callback)
    }
}
