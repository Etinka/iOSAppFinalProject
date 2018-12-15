//
//  RegisterViewController.swift
//  iOSFinalProject
//
//  Created by Eti Negev on 05/12/2018.
//  Copyright © 2018 Eti Negev. All rights reserved.
//

import UIKit
import Material

class RegisterViewController: BaseLoginViewController {
    
    @IBOutlet weak var btnRegister: UIButton!
    
    fileprivate var rePasswordField: TextField!
    fileprivate var passwordField: TextField!
    fileprivate var emailField: ErrorTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnRegister.isEnabled = false
        btnRegister.setStyle()
        
        prepareEmailField()
        preparePasswordField()
        prepareRePasswordField()
        setupAddTargetIsNotEmptyTextFields()
        
    }
    
    override func moveToApp() {
        performSegue(withIdentifier: "showAppFromRegister", sender: self)
    }
    
    override func notLoggedIn(error: String?) {
        showErrorAlert(title: "Sorry, registration wasn't succesfull")
    }
    
    fileprivate func prepareEmailField() {
        emailField = ErrorTextField()
        emailField.setEmailStyle()
        view.layout(emailField).left(sideMargin).right(sideMargin).top(initialPosition)
    }
    
    fileprivate func preparePasswordField() {
        passwordField = TextField()
        passwordField.setPasswordStyle()
        view.layout(passwordField).left(sideMargin).right(sideMargin).top(initialPosition+gap)
    }
    
    fileprivate func prepareRePasswordField() {
        rePasswordField = TextField()
        rePasswordField.setPasswordStyle()
        view.layout(rePasswordField).left(sideMargin).right(sideMargin).top(initialPosition + 2*gap)
    }
    
    private func setupAddTargetIsNotEmptyTextFields() {
        emailField.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                             for: .editingChanged)
        emailField.addTarget(self, action: #selector(textIsEmail), for: .editingDidEnd)
        passwordField.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                for: .editingChanged)
        rePasswordField.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                 for: .editingChanged)
    }
   
    
    @objc func textFieldsIsNotEmpty(sender: UITextField) {
        
        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
        
        guard
            let email = emailField.text, !email.isEmpty && email.isValidEmail(),
            let password = passwordField.text, !password.isEmpty,
            let confirmPassword = rePasswordField.text,
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
        if let userName = emailField.text, let password = passwordField.text{
            Model.instance.registerUser(email: userName, password: password)
        }
    }
}
