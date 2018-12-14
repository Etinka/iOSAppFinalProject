//
//  ViewController.swift
//  iOSFinalProject
//
//  Created by Eti Negev on 05/12/2018.
//  Copyright © 2018 Eti Negev. All rights reserved.
//

import UIKit

class LoginViewController: BaseLoginViewController {

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func moveToApp() {
        self.performSegue(withIdentifier: "showAppFromLogin", sender: self)
    }
    
    override func notLoggedIn(error: String?) {
//        showErrorAlert(title: "Sorry, login wasn't succesfull.")
    }

    @IBAction func clickedLogin(_ sender: Any) {
        NSLog("clickedLogin")
        moveToApp()
//        if let userName = nameText.text, let password = passwordText.text{
//            Model.instance.signInUser(email: userName, password: password)
//        }
    }
    
}

