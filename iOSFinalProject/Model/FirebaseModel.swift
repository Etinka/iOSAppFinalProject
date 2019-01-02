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
import FirebaseStorage

class FirebaseModel{
    
    let db: Firestore
    let propertiesCollection:CollectionReference
    var listener: ListenerRegistration?
    var authStateListener: AuthStateDidChangeListenerHandle?
    let userInfoCollection:CollectionReference
    
    init() {
        FirebaseApp.configure()
        db = Firestore.firestore()
        propertiesCollection = db.collection("properties")
        userInfoCollection = db.collection("users")
        
    }
    
    func start(){
        startAuth()
    }
    
    func stop(){
        print("Stopping Firebase")
        listener?.remove()
        if let authListener = authStateListener {
            Auth.auth().removeStateDidChangeListener(authListener)
        }
    }
    
    func startAuth(){
        authStateListener = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.sendLoggedInStatusMessage(isLoggedIn: user != nil)
        }
    }
    
    func isUserLoggedIn() -> Bool{
        return Auth.auth().currentUser != nil
    }
    
    func getUserUid() -> String{
        return Auth.auth().currentUser?.uid ?? ""
    }
    
    func registerUser(email: String, password: String){
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if  let userFB = authResult?.user {
                let user = UserInfo(_id: userFB.uid, _email: userFB.email ?? "")
                self.userInfoCollection.addDocument(data: user.toJson(), completion:nil)
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
   
    func getAllProperties(from: NSDate, callback: @escaping ([Property]) -> Void){
        listener = propertiesCollection.whereField("lastUpdate", isGreaterThan: from).addSnapshotListener({ (querySnapshot, err) in
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
    
    func updateProperty(property: Property){
        propertiesCollection.document("\(property.id)").updateData(property.toJson())
    }
    
    private func sendLoggedInStatusMessage(isLoggedIn: Bool, error: Error? = nil){
        NotificationService.userLoggedInNotification.notify(data: UserLoggedInData(_isLoggedIn: isLoggedIn, _error: error))
    }
    
    func getImage(url:String, callback:@escaping (UIImage?)->Void){
        let ref = Storage.storage().reference(forURL: url)
        ref.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if error != nil {
                callback(nil)
            } else {
                let image = UIImage(data: data!)
                callback(image)
            }
        }
    }
    
    lazy var storageRef = Storage.storage().reference(forURL: "gs://ios2018-f658d.appspot.com") //TODO change to our url
    
    func saveImage(image:UIImage, name:(String), callback:@escaping (String?)->Void){
        
        let data = image.jpegData(compressionQuality: 0.8)
        let imageRef = storageRef.child(name)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        imageRef.putData(data!, metadata: metadata) { (metadata, error) in
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                print("url: \(downloadURL)")
                callback(downloadURL.absoluteString)
            }
        }
    }
}
