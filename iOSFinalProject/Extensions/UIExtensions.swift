//
//  Extensions.swift
//  iOSFinalProject
//
//  Created by Eti Negev on 14/12/2018.
//  Copyright © 2018 Eti Negev. All rights reserved.
//

import Foundation
import UIKit
import Material

enum AppFontName: String{
    case Regular = "Heebo-Regular"
    case Medium = "Heebo-Medium"
    case Bold = "Heebo-Bold"
    case Thin = "Heebo-Thin"
    case Light = "Heebo-Light"
    case ExtraBold = "Heebo-ExtraBold"
}

extension UIButton {
    
    func setStyle(backgroundColor: UIColor = UIColor.appPink){
        self.layer.cornerRadius = 22
        self.clipsToBounds = true
        self.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.setTitleColor(UIColor.white, for: .normal)
        self.titleLabel?.font = UIFont(name:AppFontName.Medium.rawValue, size:18)
        self.setBackgroundColor(color: backgroundColor, forState: .normal)
        self.setBackgroundColor(color: backgroundColor, forState: .selected)
    }
    
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        self.clipsToBounds = true  // add this to maintain corner radius
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: forState)
        }
    }
}

extension UIViewController{
    
    func setNavigationController(){
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.appPurple, NSAttributedString.Key.font: UIFont(name: AppFontName.Medium.rawValue, size: 30)!]
        navigationController?.setStyle()
    }
}

extension UINavigationController {
    
    func setStyle(){
        self.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationBar.barTintColor = UIColor.white
        self.navigationItem.titleLabel.font = UIFont(name:AppFontName.Medium.rawValue, size:18)
        self.navigationItem.titleLabel.textColor = UIColor.appPurple
     
        if #available(iOS 11, *){
            self.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.appPurple, NSAttributedString.Key.font: UIFont(name: AppFontName.Medium.rawValue, size: 30)!]
        }
    }
}

extension ErrorTextField{
    func setEmailStyle(){
        setStyle()
        self.placeholder = "דואר אלקטרוני"
        self.error = "זו לא כתובת אימייל תקינה"
    }
}

extension TextField{
    
    func setStyle(){
        self.isPlaceholderUppercasedWhenEditing = true
        self.placeholderActiveColor = UIColor.appPurple
        self.dividerActiveColor = UIColor.appPurple
        self.visibilityIconButton?.tintColor = UIColor.appPurple.withAlphaComponent(self.isSecureTextEntry ? 0.38 : 0.54)
        self.clearButtonMode = .whileEditing
        self.font = UIFont(name:AppFontName.Light.rawValue, size:12)
        
    }
    
    func setPasswordStyle(){
        setStyle()
        self.placeholder = "סיסמה"
        self.isVisibilityIconButtonEnabled = true //todo - check if can be aligned to the left
    }  
}

extension UIColor {
    
    class var appPink: UIColor {
        let appPink = 0xe53367
        return UIColor.rgb(fromHex: appPink)
    }
    
    class var appPurple: UIColor{
        let appPurple = 0x734fbe
        return UIColor.rgb(fromHex: appPurple)
    }
    
    class func rgb(fromHex: Int) -> UIColor {
        
        let red =   CGFloat((fromHex & 0xFF0000) >> 16) / 0xFF
        let green = CGFloat((fromHex & 0x00FF00) >> 8) / 0xFF
        let blue =  CGFloat(fromHex & 0x0000FF) / 0xFF
        let alpha = CGFloat(1.0)
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

extension UILabel {
    func setTextSize(size: CGFloat) {
        font = UIFont(name:AppFontName.Medium.rawValue, size:size)
    }
}


