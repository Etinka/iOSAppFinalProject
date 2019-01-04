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
        commentText.delegate = self
        commentText.text = placeHolder
        commentText.textColor = UIColor.lightGray
        removeImageButton.isHidden = true
        
        if let index = commentIndex{
            if let comment = property.comments?.safeGet(index: index){
                commentText.textColor = UIColor.appPurple
                commentText.text = comment.text
                if let comImage = comment.imageUrl{
                    toggleButton(canAdd: false)
                    
                    //todo add image
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
        
        
        if let index = commentIndex{
            self.property.comments?.safeGet(index: index)?.text = self.commentText.text
            if let imageToSave = selectedImage{
                Model.instance.saveImage(image: imageToSave, name: "\(self.property.comments?.safeGet(index: index)?.id ?? "id")_\(UUID.init().uuidString)", callback: {(url: String?) in
                    self.property.comments?.safeGet(index: index)?.imageUrl = url
                    self.updateProperty()
                })
            }else{
                self.updateProperty()
            }
            
        }else{
//            let newComment =  Comment(_text: commentText.text, _imageUrl: imageLink, _userUid: Model.instance.getUserUid())
//            property.addComment(comment: newComment)
//            updateProperty()
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
    
    // UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        commentImage.image = selectedImage?.resizeImage(144, opaque: false)
        self.dismiss(animated: true, completion: nil)
        toggleButton(canAdd: false)
    }
    
    
    
    @IBAction func clickedRemoveImage(_ sender: Any) {
        commentImage.image = nil
        self.property.comments?.safeGet(index: commentIndex)?.imageUrl = nil
        toggleButton(canAdd: true)
    }
    
    func toggleButton(canAdd: Bool){
        removeImageButton.isHidden = canAdd
        addImageButton.isEnabled = canAdd
    }
}
