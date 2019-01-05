//
//  CommentSql.swift
//  iOSFinalProject
//
//  Created by Eti Negev on 02/01/2019.
//  Copyright © 2019 Eti Negev. All rights reserved.
//

import Foundation
import SQLite3

extension Comment{
    
    static func createTable(database: OpaquePointer?)  {
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS COMMENTS (ID TEXT PRIMARY KEY, COMMENT TEXT, IMAGE TEXT, UID TEXT, ACTIVE INTEGER, USERNAME TEXT, DATE DOUBLE)", nil, nil, &errormsg)
        if(res != 0){
            print("error creating table");
            return
        }
    }
    
    static func drop(database: OpaquePointer?)  {
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "DROP TABLE COMMENTS;", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return
        }
    }
    
    static func getAll(database: OpaquePointer?, prefix:String)->[Comment]?{
        var sqlite3_stmt: OpaquePointer? = nil
        var data = [Comment]()
        if (sqlite3_prepare_v2(database,"SELECT * from COMMENTS WHERE id LIKE '\(prefix)%';",-1,&sqlite3_stmt,nil)
            == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                let id = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
                let text = String(cString:sqlite3_column_text(sqlite3_stmt,1)!)
                let imageUrl = String(cString:sqlite3_column_text(sqlite3_stmt,2)!)
                let userUid = String(cString:sqlite3_column_text(sqlite3_stmt,3)!)
                let isActive = sqlite3_column_int64(sqlite3_stmt,4) != 0
                let userName = String(cString:sqlite3_column_text(sqlite3_stmt,5)!)
                let lud = sqlite3_column_double(sqlite3_stmt,6)
                
                if isActive {
                    data.append(Comment(_id: id, _text: text, _imageUrl: imageUrl, _userUid: userUid, _isActive: true, _date: Date(timeIntervalSince1970:lud), _userName: userName))
                }
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return data
    }
    
    static func addNew(database: OpaquePointer?, comment:Comment){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO COMMENTS(ID, COMMENT, IMAGE, UID, ACTIVE, USERNAME, DATE) VALUES (?,?,?,?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            let id = comment.id.cString(using: .utf8)
            let text = comment.text?.cString(using: .utf8)
            let imageUrl = comment.imageUrl?.cString(using: .utf8)
            let userUid = comment.userUid.cString(using: .utf8)
            let isActive = comment.isActive ? 1 : 0
            let userName = comment.userName.cString(using: .utf8)
            let date = comment.date.timeIntervalSince1970

            sqlite3_bind_text(sqlite3_stmt, 1, id,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, text,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, imageUrl,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 4, userUid,-1,nil);
            sqlite3_bind_int64(sqlite3_stmt, 5, sqlite3_int64(isActive));
            sqlite3_bind_text(sqlite3_stmt, 6, userName,-1,nil);
            sqlite3_bind_double(sqlite3_stmt, 7, date);

            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new comment with id \(comment.id) added succefully")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    static func get(database: OpaquePointer?, byId:String)->Comment?{
        
        return nil;
    }
}

