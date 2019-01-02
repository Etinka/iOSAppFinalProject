//
//  PropertyViewController.swift
//  iOSFinalProject
//
//  Created by Eti Negev on 05/12/2018.
//  Copyright © 2018 Eti Negev. All rights reserved.
//

import UIKit

class PropertyViewController: UIViewController {
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var numberOfRoomsLabel: UILabel!
    @IBOutlet weak var propertyImage: UIImageView!
    
    var propertyId:Int?
    var property:Property?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationController()
        
        if let prop = property {
            title = prop.address
            priceLabel.text = "\(prop.price) ש״ח"
            numberOfRoomsLabel.text = "מספר חדרים: \(prop.numberOfRooms)"
            if prop.imageUrl != "" {
                Model.instance.getImage(url: prop.imageUrl) {(image:UIImage?) in
                    if image != nil {
                        self.propertyImage.image = image!
                    }
                }
            }
        }
    }
}
