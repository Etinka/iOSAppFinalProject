//
//  CommentTableViewCell.swift
//  iOSFinalProject
//
//  Created by Eti Negev on 05/01/2019.
//  Copyright © 2019 Eti Negev. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentText: UITextView!
    @IBOutlet weak var commentImage: UIImageView!
    @IBOutlet weak var commentStackView: UIStackView!
    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var editButton: UIButton!
    var editClick : (() -> Void)? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setView(comment: Comment, row: Int, editClick : (() -> Void)? = nil){
        nameLabel.text = comment.userName
        commentText.text = comment.text
        dateLabel.text = comment.date.getDateString()
        contentView.tag = row
        editButton.isHidden = comment.userUid != Model.instance.getUserUid()
        self.editClick = editClick
        if !comment.imageUrl.isNilOrEmpty(){
            commentImage.isHidden = false
                Model.instance.getImage(url: comment.imageUrl!) { (image:UIImage?) in
                    if (self.contentView.tag == row){
                        if image != nil {
                            self.commentImage.image = image
                            self.commentImage.contentMode = .scaleAspectFit
                        }
                    }
            }
        }else{
            commentImage.isHidden = true
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func editClicked(_ sender: UIButton) {
        print("clicked edit")
        if let btnAction = self.editClick{
            btnAction()
        }
    }
}
