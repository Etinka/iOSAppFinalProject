//
//  PropertySql.swift
//  iOSFinalProject
//
//  Created by Eti Negev on 02/01/2019.
//  Copyright © 2019 Eti Negev. All rights reserved.
//

import Foundation
import SQLite3
import Firebase

extension Property{
    
    static func createTable(database: OpaquePointer?)  {
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS PROPERTIES (ID INTEGER PRIMARY KEY, ADDRESS TEXT, PRICE TEXT, ROOMS TEXT, IMAGE TEXT, FLOOR TEXT, ELAVATOR INTEGER, SAFE INTEGER, TYPE TEXT, SIZE TEXT, BALCONY TEXT)", nil, nil, &errormsg)
        if(res != 0){
            print("error creating table");
            return
        }
    }
    
    static func drop(database: OpaquePointer?)  {
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "DROP TABLE PROPERTIES;", nil, nil, &errormsg);
        if(res != 0){
            print("error dropping table");
            return
        }
    }
    
    static func getAll(database: OpaquePointer?)->[Property]{
        var sqlite3_stmt: OpaquePointer? = nil
        var data = [Property]()
        if (sqlite3_prepare_v2(database,"SELECT * from PROPERTIES;",-1,&sqlite3_stmt,nil)
            == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                let propId = sqlite3_column_int(sqlite3_stmt,0)
                let address = String(cString:sqlite3_column_text(sqlite3_stmt,1)!)
                let price = String(cString:sqlite3_column_text(sqlite3_stmt,2)!)
                let numberOfRooms = String(cString:sqlite3_column_text(sqlite3_stmt,3)!)
                let imageUrl = String(cString:sqlite3_column_text(sqlite3_stmt,4)!)
                let floor = String(cString:sqlite3_column_text(sqlite3_stmt,5)!)
                let elavator = (sqlite3_column_int(sqlite3_stmt,6) != 0)
                let safeRoom = (sqlite3_column_int(sqlite3_stmt,7) != 0)
                let houseType = String(cString:sqlite3_column_text(sqlite3_stmt,8)!)
                let size = String(cString:sqlite3_column_text(sqlite3_stmt,9)!)
                let balcony = String(cString:sqlite3_column_text(sqlite3_stmt,10)!)
                
                let comments = Comment.getAll(database: database, prefix:"prop\(propId)_")
                
                data.append(Property(_id: Int(propId), _address: address, _price: price, _numberOfRooms: numberOfRooms, _imageUrl: imageUrl, _floor: floor, _elevator: elavator, _safeRoom: safeRoom, _size: size, _houseType: houseType, _balcony: balcony, _comments: comments))
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return data
    }
    
    static func addNew(database: OpaquePointer?, property:Property){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO PROPERTIES(ID, ADDRESS, PRICE, ROOMS, IMAGE, FLOOR, ELAVATOR, SAFE, TYPE, SIZE, BALCONY) VALUES (?,?,?,?,?,?,?,?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            let id = property.id
            let address = property.address.cString(using: .utf8)
            let price = property.price.cString(using: .utf8)
            let numberOfRooms = property.numberOfRooms.cString(using: .utf8)
            let imageUrl = property.imageUrl.cString(using: .utf8)
            let floor = property.floor.cString(using: .utf8)
            let elevator = property.elevator ? 1 : 0
            let safeRoom = property.safeRoom ? 1 : 0
            let houseType = property.houseType.cString(using: .utf8)
            let size = property.size.cString(using: .utf8)
            let balcony = property.balcony.cString(using: .utf8)
            
            sqlite3_bind_int(sqlite3_stmt, 1, Int32(id));
            sqlite3_bind_text(sqlite3_stmt, 2, address,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, price,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 4, numberOfRooms,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 5, imageUrl,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 6, floor,-1,nil);
            sqlite3_bind_int(sqlite3_stmt, 7, Int32(elevator));
            sqlite3_bind_int(sqlite3_stmt, 8, Int32(safeRoom));
            sqlite3_bind_text(sqlite3_stmt, 9, houseType,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 10, size,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 11, balcony,-1,nil);

            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    static func get(database: OpaquePointer?, byId:String)->Property?{
        
        return nil;
    }
    
    static func getLastUpdateDate(database: OpaquePointer?)-> NSDate{
        let time = LastUpdateAt.get(database: database, tableName: "properties")
        return NSDate(timeIntervalSince1970: time + 1)
    }
    
    static func setLastUpdateDate(database: OpaquePointer?, date: NSDate){
        LastUpdateAt.set(database: database, tableName: "properties", date: date.timeIntervalSince1970);
    }
}

