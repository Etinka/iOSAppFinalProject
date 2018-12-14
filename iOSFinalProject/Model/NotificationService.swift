//
//  NotificationService.swift
//  iOSFinalProject
//
//  Created by Eti Negev on 12/12/2018.
//  Copyright © 2018 Eti Negev. All rights reserved.
//

import Foundation

class NotificationService{
    static  let userLoggedInNotification = BaseNotification<UserLoggedInData>(_name:"com.colman.finalproject.LoggedIn")
    
    class BaseNotification<T>{
        let name :String
        
        init(_name:String){
            name = _name
        }
        
        func observe(cb:@escaping (T) -> Void) -> NSObjectProtocol{
            return  NotificationCenter.default.addObserver(forName: NSNotification.Name(name) , object: nil, queue: nil, using: { (data) in
                let stData = data.userInfo?["data"] as! T
                cb(stData)
            })
        }
        
        func notify(data:T){
            NotificationCenter.default.post(name: NSNotification.Name(name), object: self, userInfo: ["data":data])
        }
        
        func removeObserver(observer: NSObjectProtocol?){
            if let notificationObserver = observer{
                NotificationCenter.default.removeObserver(notificationObserver)
            }
        }
    }
}