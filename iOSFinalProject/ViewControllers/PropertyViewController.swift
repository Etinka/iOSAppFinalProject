//
//  PropertyViewController.swift
//  iOSFinalProject
//
//  Created by Eti Negev on 05/12/2018.
//  Copyright © 2018 Eti Negev. All rights reserved.
//

import UIKit

class PropertyViewController: UITableViewController {
        
    var propertyId:Int?
    var property:Property?
    private var propObserver: NSObjectProtocol?
    var commentIndex:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationController()
        registerToPropertyChanges()
        
        if let prop = property {
            title = prop.address
            initTableView()
        }
    }
    
    func initTableView(){
        self.tableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        self.tableView.register(UINib(nibName: "PropertyInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "PropertyInfo")
        self.tableView.register(UINib(nibName: "CommentsSeperatorTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentSeparator")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddComment"{
            let commentVc:AddCommentViewController = segue.destination as! AddCommentViewController
            
            if let prop = property {
                commentVc.property = prop
                commentVc.commentIndex = self.commentIndex
            }
        }
    }
    
    override   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (property?.getOnlyActiveComments().count ?? 0) + 2
    }
    
    override  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let prop = property{
            if indexPath.row == 0{
                let cell:PropertyInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PropertyInfo", for: indexPath) as! PropertyInfoTableViewCell
                cell.setViews(prop: prop)
                return cell
                
            }else if indexPath.row == 1{
                let cell:CommentsSeperatorTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CommentSeparator", for: indexPath) as! CommentsSeperatorTableViewCell
                cell.setViews(editClick : {
                    self.commentIndex = nil
                    self.moveToComment()
                })
                return cell
            }
            else{
                let cell:CommentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
                let row = indexPath.row - 2
                if let comment = prop.getOnlyActiveComments().safeGet(index: row){
                    cell.setView(comment: comment, row: row, editClick: {
                        self.commentIndex = row
                        self.moveToComment()
                    })
                }
                return cell
            }
            
        }
        return UITableViewCell()
    }
    
    @objc func moveToComment(){
        performSegue(withIdentifier: "AddComment", sender: self)
    }
    
    override   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 420
        }
        if indexPath.row == 1{
            return 44
        }
        return 180
    }
    
    deinit {
        unregisterToPropertyChanges()
    }
    
    func unregisterToPropertyChanges(){
        NotificationService.propertyUpdated.removeObserver(observer: propObserver)
    }
    
    func registerToPropertyChanges(){
        propObserver =  NotificationService.propertyUpdated.observe() {
            (data:Any) in
            if data is Property{
                let temp = data as! Property
                if temp.id == self.property?.id{
                    self.property = temp
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
}
