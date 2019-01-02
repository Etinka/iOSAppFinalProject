//
//  Comment.swift
//  iOSFinalProject
//
//  Created by Eti Negev on 02/01/2019.
//  Copyright © 2019 Eti Negev. All rights reserved.
//

import Foundation

class Comment{
    var text: String?
    var imageUrl: String?
    var userUid:String?
    
    init(_text: String?, _imageUrl: String?, _userUid: String?) {
        self.text = _text
        self.imageUrl = _imageUrl
        self.userUid = _userUid
    }
}
