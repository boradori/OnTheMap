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
        Client.sharedInstance().getStudentLocations("100") { (success, results, error) in
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let app = UIApplication.sharedApplication()
        // check for nil
        if let toOpen = StudentInformationModel.sharedInstance().studentInformationArray[indexPath.row].mediaURL {
            // create NSURL instance
            if let url = NSURL(string: toOpen) {
                // check if your application can open the NSURL instance
                if app.canOpenURL(url) {
                    app.openURL(url)
                } else {
                    performUIUpdatesOnMain {
                        let invalidURLAlert = UIAlertController(title: "Error", message: "Invalid URL", preferredStyle: UIAlertControllerStyle.Alert)
                        invalidURLAlert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(invalidURLAlert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func refresh(sender: AnyObject) {
        loadStudentInformation()
    }
    
    @IBAction func logout(sender: AnyObject) {
        Client.sharedInstance().logoutFromUdacity { (success, results, error) in
            if success {
                performUIUpdatesOnMain {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            } else {
                performUIUpdatesOnMain {
                    let logoutAlert = UIAlertController(title: "Cannot logout", message: "\(error!.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                    logoutAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(logoutAlert, animated: true, completion: nil)
                }
            }
        }
    }
    
}