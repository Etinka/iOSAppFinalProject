//
//  Property.swift
//  iOSFinalProject
//
//  Created by Eti Negev on 05/12/2018.
//  Copyright © 2018 Eti Negev. All rights reserved.
//

import Foundation
import Firebase

class Property{
    let id: Int
    let address: String
    let price: String
    let numberOfRooms: String
    let imageUrl: String
    let floor: String
    let elevator: Bool
    let safeRoom: Bool
    let size: String
    let houseType: String
    let balcony: String
    var comments: [Comment]?
    var lastUpdate: NSDate?
    
    init(_id: Int = 0, _address: String = "", _price: String = "", _numberOfRooms: String = "", _imageUrl: String = "", _floor: String = "", _elevator:Bool = false, _safeRoom:Bool = false,_size:String = "", _houseType:String = "", _balcony:String = "", _comments: [Comment]? = nil) {
        id = _id
        address = _address
        price = _price
        numberOfRooms = _numberOfRooms
        imageUrl = _imageUrl
        floor = _floor
        elevator = _elevator
        safeRoom = _safeRoom
        size = _size
        balcony = _balcony
        houseType = _houseType
        comments = _comments
    }
    
    init(data:[String: Any]){
        id = data["id"] as! Int
        address = data["address"] as! String
        price = data["price"] as! String
        numberOfRooms = data["numberOfRooms"] as! String
        floor = data["floor"] as! String
        elevator = data["elevator"] as! Bool
        safeRoom = data["safeRoom"] as! Bool
        imageUrl = data["imageUrl"] as! String
        size = data["size"] as! String
        houseType = data["houseType"] as! String
        balcony = data["balcony"] as! String
        
        let tempComments = data["comments"] as! [[String:Any]]?
        tempComments?.forEach({(temp) in
//            if data["isActive"] != nil && (data["isActive"] as? Int == 1){
                addComment(comment: Comment(data:temp))
//            }
        })
        
        if data["lastUpdate"] != nil {
            if let lud = data["lastUpdate"] as? NSDate{
                lastUpdate = lud
            }
        }
    }
    
    func toJson() -> [String:Any] {
        var json = [String:Any]()
        json["id"] = id
        json["address"] = address
        json["price"] = price
        json["numberOfRooms"] = numberOfRooms
        json["imageUrl"] = imageUrl
        json["balcony"] = balcony
        json["size"] = size
        json["houseType"] = houseType
        json["elevator"] = elevator
        json["safeRoom"] = safeRoom
        json["comments"] = comments?.map({ (comment) -> [String:Any]  in
            comment.dictionary
        })
        
        json["lastUpdate"] = FieldValue.serverTimestamp()
        return json
    }
    
    func addComment(comment:Comment){
        if(comments == nil){
            comments = [Comment]()
        }
        comment.id = "prop\(id)_\(comment.userUid)\(comments?.count ?? 1)"
        comments?.append(comment)
    }

    func getComment(index: Int)-> Comment?{
        return comments?.safeGet(index: index)
    }
    
    func getOnlyActiveComments(){
        
    }
    
    func updateCommentIfExists(comment:Comment){
        if  let index = comments?.index(where: { (item) -> Bool in
            item.id == comment.id
        }){
            comments?[index] = comment
        }
    }
}
