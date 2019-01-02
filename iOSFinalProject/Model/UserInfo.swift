//
//  UserInfo.swift
//  iOSFinalProject
//
//  Created by Eti Negev on 02/01/2019.
//  Copyright © 2019 Eti Negev. All rights reserved.
//

import Foundation


class UserInfo {
    let id: String
    let email: String
    let name: String?
    
    init(_id: String, _email: String, _name: String? = nil) {
        id = _id
        email = _email
        name = _name
    }
    
    init(data:[String: Any]){
        id = data["id"] as! String
        email = data["email"] as! String
        name = data["name"] as? String
    }
    
    func toJson() -> [String:Any] {
        var json = [String:Any]()
        json["id"] = id
        json["email"] = email
        json["name"] = name
        return json
    }
}
