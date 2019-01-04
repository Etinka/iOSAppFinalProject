//
//  ModelSql.swift
//  iOSFinalProject
//
//  Created by Eti Negev on 02/01/2019.
//  Copyright © 2019 Eti Negev. All rights reserved.
//

import Foundation
import SQLite3

class ModelSql {
    var database: OpaquePointer? = nil
    
    init() {
        // initialize the DB
        let dbFileName = "database2.db"
        if let dir = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask).first{
            let path = dir.appendingPathComponent(dbFileName)
            if sqlite3_open(path.absoluteString, &database) != SQLITE_OK {
                print("Failed to open db file: \(path.absoluteString)")
                return
            }
            dropTables()
            createTables()
        }
        
    }
    
    func createTables() {
        Property.createTable(database: database);
        LastUpdateAt.createTable(database: database);
        Comment.createTable(database: database)
    }
    
    func dropTables(){
        Property.drop(database: database)
        LastUpdateAt.drop(database: database)
        Comment.drop(database: database)
    }
}





