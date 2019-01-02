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
    
    init(_text: String?, _imageUrl: String?) {
        self.text = _text
        self.imageUrl = _imageUrl
    }
}
