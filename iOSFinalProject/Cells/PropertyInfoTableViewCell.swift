//
//  PropertyInfoTableViewCell.swift
//  iOSFinalProject
//
//  Created by Eti Negev on 06/01/2019.
//  Copyright © 2019 Eti Negev. All rights reserved.
//

import UIKit

class PropertyInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var numberOfRoomsLabel: UILabel!
    @IBOutlet weak var propertyImage: UIImageView!
    @IBOutlet weak var safeRoomLabel: UILabel!
    @IBOutlet weak var floorLabel: UILabel!
    @IBOutlet weak var elevatorLabel: UILabel!
    @IBOutlet weak var propertyTypeLabel: UILabel!
    @IBOutlet weak var balconyLabel: UILabel!
    @IBOutlet weak var propertySizeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setLabelsStyle()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
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
    
    func setViews(prop: Property){
        setLabelsTexts(prop: prop)
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
    }
    
    func setLabelsTexts(prop: Property){
        print("Updated property")
        priceLabel.text = "\(prop.price) ש״ח"
        numberOfRoomsLabel.text = "\(prop.numberOfRooms) חדרים"
        floorLabel.text = "קומה \(prop.floor)"
        propertyTypeLabel.text = prop.houseType
        balconyLabel.text = "מרפסות \(prop.balcony)"
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
