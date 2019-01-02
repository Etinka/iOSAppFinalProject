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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "גג"
        self.setNavigationController()

        Model.instance.getAllProperties(callback: {(data:[Property]) in
            self.data = data
            self.tableView.reloadData()
        })
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
        
        cell.imageView!.tag = indexPath.row
        cell.imageView?.contentMode = .scaleAspectFit
        if st.imageUrl != "" {
            Model.instance.getImage(url: st.imageUrl) { (image:UIImage?) in
                if (cell.imageView!.tag == indexPath.row){
                    if image != nil {
                        cell.imageView?.image = image!
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
        return 130
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PropertyDetailsView"{
            let propertyDetailsVc:PropertyViewController = segue.destination as! PropertyViewController
            propertyDetailsVc.property = self.selectedProperty
        }
        
    }
    
}
