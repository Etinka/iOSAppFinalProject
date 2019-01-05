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
    private var propObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationController()
        registerToPropertyChanges()
        
        if let prop = property {
            setLabelsStyle()
            title = prop.address
            self.setLabelsTexts(prop: prop)
            
            
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
    
    deinit {
        unregisterToPropertyChanges()
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
    
    func registerToPropertyChanges(){
        propObserver =  NotificationService.propertyUpdated.observe() {
            (data:Any) in
            if data is Property{
                let temp = data as! Property
                if temp.id == self.property?.id{
                    self.property = temp
                    self.setLabelsTexts(prop: temp)
                }
            }
        }
    }
    
    func unregisterToPropertyChanges(){
        NotificationService.propertyUpdated.removeObserver(observer: propObserver)
    }
    
    func setLabelsTexts(prop: Property){
        print("Updated property")
        priceLabel.text = "\(prop.price) ש״ח"
        numberOfRoomsLabel.text = "\(prop.numberOfRooms) חדרים"
        floorLabel.text = "קומה \(prop.floor)"
        propertyTypeLabel.text = prop.houseType
        balconyLabel.text = "מרפסות \(prop.balcony)"
        propertySizeLabel.text = "\(prop.size) מ״ר"
    }
}
