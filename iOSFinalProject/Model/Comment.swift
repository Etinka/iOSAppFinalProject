//
//  Comment.swift
//  iOSFinalProject
//
//  Created by Eti Negev on 02/01/2019.
//  Copyright © 2019 Eti Negev. All rights reserved.
//

import Foundation

class Comment{
    var id:String
    var text: String?
    var imageUrl: String?
    var userUid:String
    var isActive:Bool
    var date: Date
    var userName: String
    
    init(_id: String = "", _text: String? = nil, _imageUrl: String? = nil, _userUid: String = "", _isActive: Bool = true, _date: Date = Date(), _userName: String = "משתמש") {
        self.id = _id
        self.text = _text
        self.imageUrl = _imageUrl
        self.userUid = _userUid
        self.isActive = _isActive
        self.date = _date
        self.userName = _userName
    }
    
    init(data:[String: Any]){
        id = data["id"] as! String
        userUid = data["userUid"] as! String
        text = data["text"] as? String
        imageUrl = data["imageUrl"] as? String
        isActive = data["isActive"] as! Bool
        if(data["date"] == nil){
            date = Date()
        }else{
            date = data["date"] as! Date
        }
        if(data["userName"] == nil){
            userName = "משתמש"
        }else{
            userName = data["userName"] as! String
        }
    }
    
    var dictionary:[String:Any] {
        return [
            "id":id,
            "text":text ?? "",
            "imageUrl":imageUrl ?? "",
            "userUid":userUid,
            "isActive":isActive,
            "date":date,
            "userName": userName
        ]
    }
}
