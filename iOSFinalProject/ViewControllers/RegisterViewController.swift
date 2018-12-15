//
//  RegisterViewController.swift
//  iOSFinalProject
//
//  Created by Eti Negev on 05/12/2018.
//  Copyright © 2018 Eti Negev. All rights reserved.
//

import UIKit

class RegisterViewController: BaseLoginViewController {
    
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var repasswordText: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnRegister.isEnabled = false
        btnRegister.setStyle()
        setupAddTargetIsNotEmptyTextFields()
    }
    
    override func moveToApp() {
        performSegue(withIdentifier: "showAppFromRegister", sender: self)
    }
    
    override func notLoggedIn(error: String?) {
        showErrorAlert(title: "Sorry, registration wasn't succesfull")
    }
    
    private func setupAddTargetIsNotEmptyTextFields() {
        userNameText.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                               for: .editingChanged)
        passwordText.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                               for: .editingChanged)
        repasswordText.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                 for: .editingChanged)
    }
    
    @objc func textFieldsIsNotEmpty(sender: UITextField) {
        
        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
        
        guard
            let email = userNameText.text, !email.isEmpty,
            let password = passwordText.text, !password.isEmpty,
            let confirmPassword = repasswordText.text,
            password == confirmPassword
            else
        {
            btnRegister.isEnabled = false
            return
        }
        // enable okButton if all conditions are met
        btnRegister.isEnabled = true
    }
    
    @IBAction func clickedRegister(_ sender: Any) {
        NSLog("clickedRegister")
        if let userName = userNameText.text, let password = passwordText.text{
            Model.instance.registerUser(email: userName, password: password)
        }
    }
}
