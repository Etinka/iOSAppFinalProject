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
        self.clipsToBounds = true  
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
        navigationController?.setStyle()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
}

extension UINavigationController {
    
    func setStyle(){
        self.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationBar.barTintColor = UIColor.white
        
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.appPurple, NSAttributedString.Key.font: UIFont(name: AppFontName.Medium.rawValue, size: 18)!]
        self.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.appPurple, NSAttributedString.Key.font: UIFont(name: AppFontName.Medium.rawValue, size: 30)!]
        
    }
}

extension ErrorTextField{
    func setEmailStyle(){
        setStyle()
        self.placeholder = "דואר אלקטרוני"
        self.error = "זו לא כתובת אימייל תקינה"
    }
    
    func setUserNameStyle(){
        setStyle()
        self.placeholder = "שם משתמש"
        self.error = ""
        
    }
}

extension TextField{
    
    func setStyle(fontName: AppFontName = .Light, size: CGFloat = 12, color: UIColor = UIColor.appPurple){
        self.isPlaceholderUppercasedWhenEditing = true
        self.placeholderActiveColor = UIColor.appPurple
        self.textColor = color
        self.dividerActiveColor = color
        self.visibilityIconButton?.tintColor = color.withAlphaComponent(self.isSecureTextEntry ? 0.38 : 0.54)
        self.clearButtonMode = .whileEditing
        self.font = UIFont(name:fontName.rawValue, size:size)
    }
    
    func setPasswordStyle(){
        setStyle()
        self.placeholder = "סיסמה"
        self.isVisibilityIconButtonEnabled = true 
    }  
}

extension UIColor {
    
    class var appPink: UIColor {
        let appPink = 0xe53367
        return UIColor.rgb(fromHex: appPink)
    }
    
    class var appPurple: UIColor{
        return UIColor.appPurpleWithAlpha(alpha: 1)
    }
    
    class var appPurpleDisabled: UIColor{
        return UIColor.appPurpleWithAlpha(alpha: 0.5)
    }
    
    class func appPurpleWithAlpha(alpha: CGFloat) -> UIColor{
        let appPurple = 0x734fbe
        return UIColor.rgb(fromHex: appPurple, alpha: alpha)
    }
    
    class func rgb(fromHex: Int, alpha: CGFloat = 1) -> UIColor {
        
        let red =   CGFloat((fromHex & 0xFF0000) >> 16) / 0xFF
        let green = CGFloat((fromHex & 0x00FF00) >> 8) / 0xFF
        let blue =  CGFloat(fromHex & 0x0000FF) / 0xFF
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

extension UILabel {
    func setTextSize(size: CGFloat) {
        font = UIFont(name:AppFontName.Medium.rawValue, size:size)
    }
    
    func setStyle(fontName: AppFontName = .Regular, size: CGFloat = 16, color: UIColor = UIColor.appPurple) {
        font = UIFont(name:fontName.rawValue, size:size)
        textColor = color
    }
}

extension UIImage {
    func resizeImage(_ dimension: CGFloat, opaque: Bool, contentMode: UIView.ContentMode = .scaleAspectFit) -> UIImage {
        var width: CGFloat
        var height: CGFloat
        var newImage: UIImage
        
        let size = self.size
        let aspectRatio =  size.width/size.height
        
        switch contentMode {
        case .scaleAspectFit:
            if aspectRatio > 1 {                            // Landscape image
                width = dimension
                height = dimension / aspectRatio
            } else {                                        // Portrait image
                height = dimension
                width = dimension * aspectRatio
            }
            
        default:
            fatalError("UIIMage.resizeToFit(): FATAL: Unimplemented ContentMode")
        }
        
        if #available(iOS 10.0, *) {
            let renderFormat = UIGraphicsImageRendererFormat.default()
            renderFormat.opaque = opaque
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: renderFormat)
            newImage = renderer.image {
                (context) in
                self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), opaque, 0)
            self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        
        return newImage
    }
}
