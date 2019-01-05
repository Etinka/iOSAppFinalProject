//
//  PropertyViewController.swift
//  iOSFinalProject
//
//  Created by Eti Negev on 05/12/2018.
//  Copyright © 2018 Eti Negev. All rights reserved.
//

import UIKit

class PropertyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var numberOfRoomsLabel: UILabel!
    @IBOutlet weak var propertyImage: UIImageView!
    @IBOutlet weak var safeRoomLabel: UILabel!
    @IBOutlet weak var floorLabel: UILabel!
    @IBOutlet weak var elevatorLabel: UILabel!
    @IBOutlet weak var propertyTypeLabel: UILabel!
    @IBOutlet weak var balconyLabel: UILabel!
    @IBOutlet weak var propertySizeLabel: UILabel!
    
    private var commentsTableView: UITableView!

    var propertyId:Int?
    var property:Property?
    private var propObserver: NSObjectProtocol?
    var commentIndex:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationController()
        registerToPropertyChanges()
        
        if let prop = property {
            setLabelsStyle()
            title = prop.address
            self.setLabelsTexts(prop: prop)
            
            initComentsTableView()
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
    
    func initComentsTableView(){
        let y: CGFloat = (self.view.frame.height / 3) * 2
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height / 3
        

        let separator = UIView(frame: CGRect(x: 10, y: y, width: displayWidth - 20, height: 1))
        separator.backgroundColor = UIColor.appPurple
        self.view.addSubview(separator)
        
        commentsTableView = UITableView(frame: CGRect(x: 0, y: y + 2, width: displayWidth, height: displayHeight - 2))
        commentsTableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        commentsTableView.dataSource = self
        commentsTableView.delegate = self
        self.view.addSubview(commentsTableView)
        
        let addButton = UIButton(frame: CGRect(x: 8, y: y - 30, width: 60, height: 44))
        addButton.setStyle()
        addButton.setImage(UIImage(named: "AddComment"), for: .normal)
        addButton.addTarget(self, action: #selector(moveToComment), for: .touchDown)
        self.view.addSubview(addButton)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addComment"{
            let commentVc:AddCommentViewController = segue.destination as! AddCommentViewController
            
            if let prop = property {
                commentVc.property = prop
                commentVc.commentIndex = self.commentIndex
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
                    self.commentsTableView.reloadData()
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return property?.comments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CommentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell

        if let prop = property{
            if let comment = prop.comments?.safeGet(index: indexPath.row){
                cell.setView(comment: comment, row: indexPath.row, editClick: {
                    self.commentIndex = indexPath.row
                    self.moveToComment()
                })
            }
        }
        return cell
    }
    
    @objc func moveToComment(){
        performSegue(withIdentifier: "addComment", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    deinit {
        unregisterToPropertyChanges()
    }
}
