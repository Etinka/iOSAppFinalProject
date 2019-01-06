//
//  CommentsSeperatorTableViewCell.swift
//  iOSFinalProject
//
//  Created by Eti Negev on 06/01/2019.
//  Copyright © 2019 Eti Negev. All rights reserved.
//

import UIKit

class CommentsSeperatorTableViewCell: UITableViewCell {
    var editClick : (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setViews(editClick : (() -> Void)? = nil){
        self.editClick = editClick
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
    }
    
    @IBAction func editClicked(_ sender: UIButton) {
        print("clicked edit")
        if let btnAction = self.editClick{
            btnAction()
        }
    }
}
