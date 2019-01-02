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
    let price: String
    let numberOfRooms: String
    let imageUrl: String
    let floor: String
    let elevator: Bool
    let safeRoom: Bool
    var comments: [Comment]?
    
    init(_id: NSNumber, _address: String, _price: String, _numberOfRooms: String, _imageUrl: String, _floor: String, _elevator:Bool, _safeRoom:Bool,_comments: [Comment]? = nil) {
        id = _id
        address = _address
        price = _price
        numberOfRooms = _numberOfRooms
        imageUrl = _imageUrl
        floor = _floor
        elevator = _elevator
        safeRoom = _safeRoom
        comments = _comments
    }
    
    init(data:[String: Any]){
        id = data["id"] as! NSNumber
        address = data["address"] as! String
        price = data["price"] as! String
        numberOfRooms = data["numberOfRooms"] as! String
        floor = data["floor"] as! String
        elevator = data["elevator"] as! Bool
        safeRoom = data["safeRoom"] as! Bool
        imageUrl = data["imageUrl"] as! String
        comments = data["comments"] as!  [Comment]?
    }
    
    
    
}
