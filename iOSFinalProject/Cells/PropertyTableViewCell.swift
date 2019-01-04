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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
    }

}
