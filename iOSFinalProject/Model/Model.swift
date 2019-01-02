//
//  Model.swift
//  iOSFinalProject
//
//  Created by Eti Negev on 05/12/2018.
//  Copyright © 2018 Eti Negev. All rights reserved.
//

import Foundation
import UIKit

class Model {
    
    static let instance:Model = Model()
    
    var modelFirebase = FirebaseModel()
    
    func start(){
        modelFirebase.start()
    }
    
    func stop(){
        modelFirebase.stop()
    }
    
    func isLoggedIn() -> Bool{
       return modelFirebase.isUserLoggedIn()
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
    
    func getImage(url:String, callback:@escaping (UIImage?)->Void){
        let _url = URL(string: url)
        let localImageName = _url!.lastPathComponent
        if let image = self.getImageFromFile(name: localImageName){
            callback(image)
            print("got image from cache \(localImageName)")
        }else{
            modelFirebase.getImage(url: url){(image:UIImage?) in
                if (image != nil){
                    //3. save the image localy
                    self.saveImageToFile(image: image!, name: localImageName)
                }
                //4. return the image to the user
                callback(image)
                print("got image from firebase \(localImageName)")
            }
        }
    }
    
    func saveImageToFile(image:UIImage, name:String){
        if let data = image.jpegData(compressionQuality:0.8) {
            let filename = getDocumentsDirectory().appendingPathComponent(name)
            try? data.write(to: filename)
        }
    }
    
    func saveImage(image:UIImage, name:(String),callback:@escaping (String?)->Void){
        modelFirebase.saveImage(image: image, name: name, callback: callback)
        
    }
    
    func getImageFromFile(name:String)->UIImage?{
        let filename = getDocumentsDirectory().appendingPathComponent(name)
        return UIImage(contentsOfFile:filename.path)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
