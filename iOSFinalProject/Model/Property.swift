//
//  Property.swift
//  iOSFinalProject
//
//  Created by Eti Negev on 05/12/2018.
//  Copyright © 2018 Eti Negev. All rights reserved.
//

import Foundation

class Property{
    let id: NSNumber
    let address: String
    
    init(_id: NSNumber, _address: String) {
        id = _id
        address = _address
    }
    
    init(data:[String: Any]){
        id = data["id"] as! NSNumber
        address = data["address"] as! String
    }
    
    
    
}
