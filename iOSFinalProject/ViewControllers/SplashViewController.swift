//
//  SplashViewController.swift
//  iOSFinalProject
//
//  Created by Eti Negev on 15/12/2018.
//  Copyright © 2018 Eti Negev. All rights reserved.
//

import Foundation


class SplashViewController: BaseLoginViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        if Model.instance.isLoggedIn(){
            moveToApp()
        }else{
            moveToLogin()
        }
    }
    
    override func moveToApp(){
        self.performSegue(withIdentifier: "showApp", sender: self)
    }
    
    func moveToLogin(){
        self.performSegue(withIdentifier: "showLogin", sender: self)
    }
    
    override  func notLoggedIn(error: String?){
        moveToLogin()
    }
}
