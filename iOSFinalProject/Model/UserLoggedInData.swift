//
//  User.swift
//  iOSFinalProject
//
//  Created by Eti Negev on 09/12/2018.
//  Copyright © 2018 Eti Negev. All rights reserved.
//

import Foundation

class UserLoggedInData {
    let isLoggedIn: Bool
    let error:Error?
    
    init(_isLoggedIn:Bool, _error: Error? = nil) {
        isLoggedIn = _isLoggedIn
        error = _error
    }
    
}
