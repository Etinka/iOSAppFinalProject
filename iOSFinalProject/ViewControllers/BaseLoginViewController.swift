//
//  BaseLoginViewController.swift
//  iOSFinalProject
//
//  Created by Eti Negev on 09/12/2018.
//  Copyright © 2018 Eti Negev. All rights reserved.
//

import UIKit

class BaseLoginViewController: UIViewController {
    
    private var notificationObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        registerToAuthChanges()
    }
    override func viewDidDisappear(_ animated: Bool) {
        unregisterToAuthChanges()
    }
    
    func registerToAuthChanges(){
        notificationObserver =  NotificationService.userLoggedInNotification.observe(cb: {(userLoggedInData) in
            if(userLoggedInData.isLoggedIn){
                self.moveToApp()
            }else{
                self.notLoggedIn(error: userLoggedInData.error?.localizedDescription)
            }
        })
    }
    
    func unregisterToAuthChanges(){
        NotificationService.userLoggedInNotification.removeObserver(observer: notificationObserver)
    }
    
    func moveToApp(){
        self.performSegue(withIdentifier: "showApp", sender: self)
    }
    
    func notLoggedIn(error: String?){
        self.performSegue(withIdentifier: "showLogin", sender: self)
    }
    
    func showErrorAlert(title: String?){
        let alert = UIAlertController(title: title, message:nil, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
