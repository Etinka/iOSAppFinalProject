//
//  PropertyTableViewCell.swift
//  iOSFinalProject
//
//  Created by Eti Negev on 05/12/2018.
//  Copyright © 2018 Eti Negev. All rights reserved.
//

import UIKit

class PropertyTableViewCell: UITableViewCell {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var numOfRoomsLabel: UILabel!
    @IBOutlet weak var detailsStackView: UIStackView!
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var detailsView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setLabelsStyle()
    }
    
    func setLabelsStyle(){
        priceLabel.setStyle(fontName: .Bold, size: 20, color: UIColor.white)
        addressLabel.setStyle(size: 14)
        numOfRoomsLabel.setStyle(size: 14)
    }
    
    func setViews(st: Property, row: Int){
        addressLabel.text = st.address
        priceLabel.text = " ₪ \(st.price)"
        numOfRoomsLabel.text = "מספר חדרים: \(st.numberOfRooms)"
        
        contentView.tag = row
        if st.imageUrl != "" {
            Model.instance.getImage(url: st.imageUrl) { (image:UIImage?) in
                if (self.contentView.tag == row){
                    if image != nil {
                        let imageView = UIImageView(frame: CGRect(x: 10, y: 0, width: self.frame.width - 20, height: self.frame.height - 10))
                        imageView.layer.cornerRadius = 15
                        imageView.layer.masksToBounds = true
                        imageView.image = image
                        self.addSubview(imageView)
                        self.sendSubviewToBack(imageView)
                    }
                }
            }
            
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
    }

}
