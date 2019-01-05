//
//  AddCommentViewController.swift
//  iOSFinalProject
//
//  Created by Eti Negev on 07/12/2018.
//  Copyright © 2018 Eti Negev. All rights reserved.
//

import UIKit

class AddCommentViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    var property: Property = Property()
    var commentIndex: Int?
    let placeHolder = "הכנס תגובה"
    var selectedImage:UIImage?
    
    @IBOutlet weak var commentText: UITextView!
    @IBOutlet weak var addButton: LoadingButton!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var removeImageButton: UIButton!
    @IBOutlet weak var commentImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = property.address
        addButton.setStyle()
        addDeleteButton()
        
        commentText.delegate = self
        commentText.text = placeHolder
        commentText.textColor = UIColor.lightGray
        removeImageButton.isHidden = true
        commentImage.layer.borderWidth = 1
        commentImage.layer.cornerRadius = 8
        commentImage.layer.masksToBounds = true
        commentImage.layer.borderColor = UIColor.appPink.cgColor
        
        if let index = commentIndex{
            if let comment = property.getOnlyActiveComments().safeGet(index: index){
                commentText.textColor = UIColor.appPurple
                commentText.text = comment.text
                
                if let comImage = comment.imageUrl.getValueOrNil(){
                    toggleButton(canAdd: false)
                    
                    Model.instance.getImage(url: comImage) {(image:UIImage?) in
                        if image != nil {
                            self.commentImage.image = image?.resizeImage(144, opaque: false)
                        }else{
                            self.toggleButton(canAdd: true)
                        }
                    }
                }else{
                    toggleButton(canAdd: true)
                }
                
                addButton.setTitle("שמור", for: .normal)
            }
        }
    }
    
    func addDeleteButton(){
        if commentIndex != nil{
            let delete = UIBarButtonItem(title: "מחק", style: .plain, target: self, action:  #selector(clickedDelete))
            delete.tintColor = UIColor.appPurple
            navigationItem.rightBarButtonItem = delete
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.appPurple
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeHolder
            textView.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func addCommentClicked(_ sender: Any) {
        addButton.showLoading()
        
        var comment = Comment()
        if let index = commentIndex{
            //Update
            comment = self.property.getOnlyActiveComments().safeGet(index: index) ?? Comment()
            comment.text = self.commentText.text
        }else{
            //New
            comment = Comment(_text: commentText.text, _imageUrl: nil, _userUid: Model.instance.getUserUid(), _isActive: true, _userName: Model.instance.getCurrentUserName())
            property.addComment(comment: comment)
        }
        
        if let imageToSave = selectedImage{
            Model.instance.saveImage(image: imageToSave, name: "\(comment.id)_\(UUID.init().uuidString)", callback: {(url: String?) in
                comment.imageUrl = url
                self.property.updateCommentIfExists(comment: comment)
                self.updateProperty()
            })
        }else{
            self.updateProperty()
        }
    }
    
    func updateProperty(){
        Model.instance.updateProperty(property: self.property, callback: { (success:Bool) in
            if success{
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    @IBAction func clickedAddImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType =
                UIImagePickerController.SourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func clickedRemoveImage(_ sender: Any) {
        commentImage.image = UIImage(named: "AddImagePurple")
        self.property.getOnlyActiveComments().safeGet(index: commentIndex)?.imageUrl = nil
        toggleButton(canAdd: true)
    }
    
    func toggleButton(canAdd: Bool){
        removeImageButton.isHidden = canAdd
        addImageButton.isEnabled = canAdd
    }
    
    // UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        commentImage.image = selectedImage?.resizeImage(144, opaque: false)
        self.dismiss(animated: true, completion: nil)
        toggleButton(canAdd: false)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func clickedDelete(){
        let alert = UIAlertController(title: "האם אתה בטוח?", message:nil, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "לא", style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "כן", style: UIAlertAction.Style.destructive, handler:{(action:UIAlertAction) in
            if let index = self.commentIndex{
                let comment = self.property.getOnlyActiveComments().safeGet(index: index) ?? Comment()
                comment.isActive = false
                self.updateProperty()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
