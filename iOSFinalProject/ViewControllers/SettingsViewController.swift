//
//  SettingsViewController.swift
//  iOSFinalProject
//
//  Created by Eti Negev on 06/01/2019.
//  Copyright © 2019 Eti Negev. All rights reserved.
//

import UIKit
import Material

class SettingsViewController: UIViewController {

    @IBOutlet weak var updateBtn: UIButton!

    @IBOutlet weak var userNameText: TextField!
    @IBOutlet weak var userNameLable: UILabel!
    @IBOutlet weak var logoutBtn: LoadingButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailText: TextField!
    @IBOutlet weak var passwordText: TextField!
    @IBOutlet weak var passwordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "הגדרות"
        self.setNavigationController()

        setStyles()
        
        if let userInfo = Model.instance.getCurrentUserInfo(){
            emailText.text = userInfo.email
            userNameText.text = userInfo.name
        }
    }
    
    func setStyles(){
        logoutBtn.setStyle()
        updateBtn.setStyle()
        logoutBtn.setBackgroundColor(color: UIColor.red, forState: .normal)
        
        userNameLable.setStyle(fontName: .Bold, size: 18)
        emailLabel.setStyle(fontName: .Bold, size: 18)
        passwordLabel.setStyle(fontName: .Bold, size: 18)

        userNameText.setStyle(fontName: AppFontName.Regular, size: 18, color: UIColor.appPurpleDisabled)
        emailText.setStyle(fontName: AppFontName.Regular, size: 18, color: UIColor.appPurpleDisabled)
        passwordText.setStyle(fontName: AppFontName.Regular, size: 18, color: UIColor.appPurpleDisabled)
        passwordText.isVisibilityIconButtonEnabled = true

        emailText.isEnabled = false
        userNameText.isEnabled = false
        passwordText.isEnabled = false
    }
    
    @IBAction func clickedLogin(_ sender: Any) {
        Model.instance.logout()
        performSegue(withIdentifier: "GoToLogin", sender: self)
    }
    

}
