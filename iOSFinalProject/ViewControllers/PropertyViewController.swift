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
    @IBOutlet weak var propertyTypeLabel: UILabel!
    @IBOutlet weak var balconyLabel: UILabel!
    @IBOutlet weak var propertySizeLabel: UILabel!
    
    var propertyId:Int?
    var property:Property?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationController()
        
        if let prop = property {
            setLabelsStyle()

            title = prop.address
            priceLabel.text = " ₪ \(prop.price)"
            numberOfRoomsLabel.text = "\(prop.numberOfRooms) חדרים"
            floorLabel.text = "קומה \(prop.floor)"
            propertyTypeLabel.text = prop.houseType
            balconyLabel.text = "\(prop.balcony) מרפסות"
            propertySizeLabel.text = "\(prop.size) מ״ר"
            
            
            let hasElevator = prop.elevator;
            if hasElevator {
                elevatorLabel.text = "מעלית: יש"
            }
            else {
                elevatorLabel.text = "מעלית: אין"
            }
            let hasSafeRoom = prop.safeRoom;
            if hasSafeRoom {
                safeRoomLabel.text = "ממ״ד: יש"
            }
            else {
                safeRoomLabel.text = "ממ״ד: אין"
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
    
    func setLabelsStyle(){
        priceLabel.setStyle(fontName: .Bold, size: 24)
        numberOfRoomsLabel.setStyle(size: 14)
        floorLabel.setStyle(size: 14)
        elevatorLabel.setStyle(size: 14)
        safeRoomLabel.setStyle(size: 14)
        balconyLabel.setStyle(size: 14)
        propertyTypeLabel.setStyle(size: 14)
        propertySizeLabel.setStyle(size: 14)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addComment"{
            let commentVc:AddCommentViewController = segue.destination as! AddCommentViewController
            
            if let prop = property {
                commentVc.property = prop
            }
        }
        
    }
}
