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
        cell.priceLabel.text = " ₪ \(st.price)"
        cell.numOfRoomsLabel.text = "מספר חדרים: \(st.numberOfRooms)"
        cell.addressLabel.textColor = UIColor.appPurple
        cell.numOfRoomsLabel.textColor = UIColor.appPurple
        cell.priceLabel.textColor = UIColor.white
        
        cell.contentView.tag = indexPath.row
        if st.imageUrl != "" {
            Model.instance.getImage(url: st.imageUrl) { (image:UIImage?) in
                if (cell.contentView.tag == indexPath.row){
                    if image != nil {
                        let imageView = UIImageView(frame: CGRect(x: 10, y: 0, width: cell.frame.width - 20, height: cell.frame.height - 10))
                        imageView.layer.cornerRadius = 15
                        imageView.layer.masksToBounds = true
                        imageView.image = image
                        cell.backgroundView = UIView()
                        cell.backgroundView?.layer.cornerRadius = 15
                        cell.addSubview(imageView)
                        cell.sendSubviewToBack(imageView)
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
        NotificationService.propertiesListUpdated.removeObserver(observer: listObserver)
    }
}
