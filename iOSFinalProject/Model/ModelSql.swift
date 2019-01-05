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
    private let versionKey = "sql_version"
    var database: OpaquePointer? = nil
    let version = 1
    
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
            dropTablesIfNeeded()
            createTables()
        }
    }
    
    func createTables() {
        UserDefaults.standard.set(version, forKey: versionKey)
        Property.createTable(database: database);
        LastUpdateAt.createTable(database: database);
        Comment.createTable(database: database)
    }
    
    func dropTablesIfNeeded(){
        let userDefaults = UserDefaults.standard
        if let sqlVersion = userDefaults.value(forKey: versionKey) {
            if sqlVersion is Int && (version > sqlVersion as! Int ) {
                dropTables()
            }
        }else{
            dropTables()
        }
    }
    
    func dropTables(){
        print("Dropping tables")
        Property.drop(database: database)
        LastUpdateAt.drop(database: database)
        Comment.drop(database: database)
    }
}





