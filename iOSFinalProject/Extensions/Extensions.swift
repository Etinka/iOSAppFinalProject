//
//  Extensions.swift
//  iOSFinalProject
//
//  Created by Eti Negev on 14/12/2018.
//  Copyright © 2018 Eti Negev. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func setStyle(backgroundColor: UIColor = UIColor.appPink){
        self.layer.cornerRadius = 25
        self.clipsToBounds = true
        self.backgroundColor = backgroundColor
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.setTitleColor(UIColor.white, for: .normal)
        self.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 18)
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
