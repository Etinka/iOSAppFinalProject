//
//  PropertiesTableViewController.swift
//  iOSFinalProject
//
//  Created by Eti Negev on 05/12/2018.
//  Copyright © 2018 Eti Negev. All rights reserved.
//

import UIKit

class PropertiesTableViewController: UITableViewController {
    var data = [Property]()
    var selectedProperty:Property?
    private var listObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "גג"
        self.setNavigationController()
        registerToListChanges()
        Model.instance.getAllProperties()
    }
    
    deinit{
       unregisterToListChanges()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PropertyTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PropertyCell", for: indexPath) as! PropertyTableViewCell
        
        let st = data[indexPath.row]
        cell.addressLabel.text = st.address
        cell.priceLabel.text = "\(st.price) ש״ח"
        cell.numOfRoomsLabel.text = "מספר חדרים: \(st.numberOfRooms)"
        
        cell.addressLabel.textColor = UIColor.appPurple
        cell.priceLabel.textColor = UIColor.appPurple
        cell.numOfRoomsLabel.textColor = UIColor.appPurple
        
        cell.imageView!.tag = indexPath.row
        if st.imageUrl != "" {
            Model.instance.getImage(url: st.imageUrl) { (image:UIImage?) in
                if (cell.imageView!.tag == indexPath.row){
                    cell.imageView?.image = nil
                    if image != nil {
                        //cell.imageView?.image = image!
                        
                        let size = image!.size
                        
                        let widthRatio  = (UIScreen.main.bounds.width - CGFloat(integerLiteral: 32))  / size.width
                        let heightRatio = CGFloat(integerLiteral: 180) / size.height
                        
                        // Figure out what our orientation is, and use that to form the rectangle
                        var newSize: CGSize
                        if(widthRatio > heightRatio) {
                            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
                        } else {
                            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
                        }
                        
                        // This is the rect that we've calculated out and this is what is actually used below
                        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
                        
                        // Actually do the resizing to the rect using the ImageContext stuff
                        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
                        image!.draw(in: rect)
                        let newImage = UIGraphicsGetImageFromCurrentImageContext()
                        UIGraphicsEndImageContext()
                        
                        cell.imageView?.image = newImage!

                        
                        //let resizedImage = image?.resize(toHeight: CGFloat(integerLiteral: 180))
                        //cell.imageView?.image = resizedImage?.resize(toWidth: (UIScreen.main.bounds.width - CGFloat(integerLiteral: 32)))
                        //cell.imageView?.image = resizedImage?.resize(toWidth: CGFloat(integerLiteral: 120))
                        //cell.imageView?.frame.size = CGSize(width: UIScreen.main.bounds.width, height: 180)
                        //cell.contentView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 20, right: 16)
                        //cell.imageView?.topAnchor.constraint(lessThanOrEqualTo: cell.contentView.layoutMarginsGuide.topAnchor)
                        cell.imageView?.layer.zPosition = -5
                        //cell.imageView?.contentMode = .scaleAspectFit

//                        let background = image!
//
//                        var imageView : UIImageView!
//                        imageView = UIImageView(frame: UIScreen.main.bounds)
//                        imageView.contentMode = .scaleAspectFill
//                        imageView.clipsToBounds = true
//                        let resizedImage = background.resize(toHeight: 180)
//                        imageView.image = resizedImage?.resize(toWidth: UIScreen.main.bounds.width - CGFloat(bitPattern: 32 ))
//                        cell.addSubview(imageView)
//                        cell.sendSubviewToBack(imageView)

                    }
                }
            }
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("user select row \(indexPath.row)")
        selectedProperty = data[indexPath.row]
        self.performSegue(withIdentifier: "PropertyDetailsView", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PropertyDetailsView"{
            let propertyDetailsVc:PropertyViewController = segue.destination as! PropertyViewController
            propertyDetailsVc.property = self.selectedProperty
        }
        
    }
    
    func registerToListChanges(){
        listObserver =  NotificationService.propertiesListUpdated.observe() {
            (data:Any) in
            self.data = data as! [Property]
            self.tableView.reloadData()
        }
    }
    
    func unregisterToListChanges(){
        NotificationService.userLoggedInNotification.removeObserver(observer: listObserver)
    }
}
