//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Youngsun Paik on 6/22/16.
//  Copyright © 2016 Youngsun Paik. All rights reserved.
//

import Foundation
import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loadStudentInformation()
    }
    

    func loadStudentInformation() {
        Client.sharedInstance().getStudentLocations("100", skip: "10") { (success, results, error) in
            if success {
                StudentInformationModel.sharedInstance().studentInformationArray.removeAll()
                
                for studentLocation in results {
                    let studentLocation = StudentInformation(dictionary: studentLocation)
                    
                    StudentInformationModel.sharedInstance().studentInformationArray.append(studentLocation)
                }
                performUIUpdatesOnMain {
                    self.tableView.reloadData()
                }
            } else {
                performUIUpdatesOnMain {
                    let credentialsAlert = UIAlertController(title: "Cannot download due to bad connectivity", message: "\(error!.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                    credentialsAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(credentialsAlert, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentInformationModel.sharedInstance().studentInformationArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("studentInfoTableCell") as! StudentInfoTableCell
        let studentInfoCell = StudentInformationModel.sharedInstance().studentInformationArray[indexPath.row]
        
        cell.studentName.text = "\(studentInfoCell.firstName!) \(studentInfoCell.lastName!)"
        
        return cell
        
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        <#code#>
//    }
    
}