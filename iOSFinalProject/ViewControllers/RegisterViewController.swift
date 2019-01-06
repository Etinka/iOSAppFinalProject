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

    let initialPosition:CGFloat = 220

    @IBOutlet weak var registerBtn: LoadingButton!
    
    fileprivate var rePasswordField: TextField!
    fileprivate var passwordField: TextField!
    fileprivate var emailField: ErrorTextField!
    fileprivate var nameField: ErrorTextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerBtn.isEnabled = false
        registerBtn.setStyle()
        
        prepareEmailField()
        prepareNameField()
        preparePasswordField()
        prepareRePasswordField()
        setupAddTargetIsNotEmptyTextFields()
        
    }
    
    override func moveToApp() {
        performSegue(withIdentifier: "showAppFromRegister", sender: self)
    }
    
    override func notLoggedIn(error: String?) {
        registerBtn.hideLoading()
        showErrorAlert(title: "Sorry, registration wasn't succesfull")
    }
    
    fileprivate func prepareEmailField() {
        emailField = ErrorTextField()
        emailField.setEmailStyle()
        view.layout(emailField).left(sideMargin).right(sideMargin).top(initialPosition)
    }
    
    fileprivate func prepareNameField() {
        nameField = ErrorTextField()
        nameField.setUserNameStyle()
        view.layout(nameField).left(sideMargin).right(sideMargin).top(initialPosition + gap)
    }
    
    fileprivate func preparePasswordField() {
        passwordField = TextField()
        passwordField.setPasswordStyle()
        view.layout(passwordField).left(sideMargin).right(sideMargin).top(initialPosition + 2*gap)
    }
    
    fileprivate func prepareRePasswordField() {
        rePasswordField = TextField()
        rePasswordField.setPasswordStyle()
        view.layout(rePasswordField).left(sideMargin).right(sideMargin).top(initialPosition + 3*gap)
    }
    
    private func setupAddTargetIsNotEmptyTextFields() {
        emailField.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                             for: .editingChanged)
        nameField.addTarget(self, action: #selector(textFieldsIsNotEmpty),
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
            let name = nameField.text, !name.isEmpty,
            let password = passwordField.text, !password.isEmpty,
            let confirmPassword = rePasswordField.text,
            password == confirmPassword
            else
        {
            registerBtn.isEnabled = false
            return
        }
        // enable okButton if all conditions are met
        registerBtn.isEnabled = true
    }

    @IBAction func clickedRegister(_ sender: Any) {
        NSLog("clickedRegister")
        registerBtn.showLoading()
        if let email = emailField.text, let password = passwordField.text, let userName = nameField.text{
            Model.instance.registerUser(email: email, password: password, userName: userName)
        }
    }
}
