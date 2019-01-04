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
    @IBOutlet weak var safeRoomLabel: UILabel!
    @IBOutlet weak var floorLabel: UILabel!
    @IBOutlet weak var elevatorLabel: UILabel!
    
    var propertyId:Int?
    var property:Property?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationController()
        
        if let prop = property {
            title = prop.address
            priceLabel.text = "\(prop.price) ש״ח"
            numberOfRoomsLabel.text = "מספר חדרים: \(prop.numberOfRooms)"
            floorLabel.text = "קומה: \(prop.floor)"
            
            priceLabel.textColor = UIColor.appPurple
            numberOfRoomsLabel.textColor = UIColor.appPurple
            floorLabel.textColor = UIColor.appPurple
            elevatorLabel.textColor = UIColor.appPurple
            safeRoomLabel.textColor = UIColor.appPurple
            
            priceLabel!.setTextSize(size: 24)
            numberOfRoomsLabel!.setTextSize(size: 14)
            floorLabel!.setTextSize(size: 14)
            elevatorLabel!.setTextSize(size: 14)
            safeRoomLabel!.setTextSize(size: 14)
            
            let hasElevator = prop.elevator;
            if hasElevator {
                elevatorLabel.text = "מעלית: V"
            }
            else {
                elevatorLabel.text = "מעלית: X"
            }
            let hasSafeRoom = prop.safeRoom;
            if hasSafeRoom {
                safeRoomLabel.text = "ממ״ד: V"
            }
            else {
                safeRoomLabel.text = "ממ״ד: X"
            }
            if prop.imageUrl != "" {
                Model.instance.getImage(url: prop.imageUrl) {(image:UIImage?) in
                    if image != nil {
                        let resizedImage = image?.resize(toHeight: 120)
                        self.propertyImage.image = resizedImage
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addComment"{
            let commentVc:AddCommentViewController = segue.destination as! AddCommentViewController
            
            if let prop = property {
                commentVc.property = prop
                if prop.comments != nil {//todo
                    commentVc.commentIndex = 0
                }
            }
        }
        
    }
}
