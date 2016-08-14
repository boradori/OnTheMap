//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Youngsun Paik on 6/22/16.
//  Copyright © 2016 Youngsun Paik. All rights reserved.
//

import Foundation
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

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
                self.alertMessage("Cannot download due to bad connectivity", message: "\(error!.localizedDescription)")
            }
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentInformationModel.sharedInstance().studentInformationArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("studentInfoTableCell") as! StudentInfoTableCell
        let studentInfoCell = StudentInformationModel.sharedInstance().studentInformationArray[indexPath.row]
        
        if let firstName = studentInfoCell.firstName, let lastName = studentInfoCell.lastName {
            cell.studentName.text = "\(firstName) \(lastName)"
        } else {
            print("some data do not have firstName and lastName")
        }
        
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
                    alertMessage("Error", message: "Invalid URL")
                }
            }
        }
    }
    
    @IBAction func refresh(sender: AnyObject) {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        
        func stopAnimatingActivityIndicator() {
            performUIUpdatesOnMain {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
        }
        
        loadStudentInformation()
        stopAnimatingActivityIndicator()
    }
    
    @IBAction func logout(sender: AnyObject) {
        FBSDKLoginManager().logOut()
        Client.sharedInstance().logoutFromUdacity { (success, results, error) in
            if success {
                performUIUpdatesOnMain {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            } else {
                self.alertMessage("Cannot logout", message: "\(error!.localizedDescription)")
            }
        }
    }
    
}