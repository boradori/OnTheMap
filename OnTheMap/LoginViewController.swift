//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Youngsun Paik on 6/6/16.
//  Copyright © 2016 Youngsun Paik. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var debugTextLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var session = NSURLSession.sharedSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.keyboardType = .EmailAddress
        passwordField.secureTextEntry = true
        
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    @IBAction func loginPressed(sender: AnyObject) {
        
        self.showHideActivityIndicator(true)
        
        Client.sharedInstance().authenticateWithViewController(emailField.text!, password: passwordField.text!, hostViewController: self) { (success, sessionID, userID, error, badCredentials) in
            performUIUpdatesOnMain {
                if success {
                    self.showHideActivityIndicator(false)
                    Client.sharedInstance().sessionID = sessionID
                    Client.sharedInstance().userID = userID
                    
                    Client.sharedInstance().getStudentName({ (success, firstName, lastName, error) in
                        if success {
                            Client.sharedInstance().firstName = firstName
                            Client.sharedInstance().lastName = lastName
                        } else {
                            self.alertMessage("Parsing User Information Error", message: "Failed to get user information")
                        }
                    })
                    self.completeLogin()
                    
                } else if badCredentials != nil {
                    self.showHideActivityIndicator(false)
                    self.alertMessage("Credential Error", message: "\(badCredentials)")
                    
                } else if reachabilityStatus == kNOTREACHABLE { // Reachability for no internet connection or I could just use error!.localizedDescription for the alert
                    self.showHideActivityIndicator(false)
                    self.alertMessage("No Internet Connectivity", message: "Make sure your device is connected to the internet.")
                }
            }
        }
    }
    
    private func completeLogin() {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("tabBarController") as! UITabBarController
        presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func signUp(sender: AnyObject) {
        performUIUpdatesOnMain {
            UIApplication.sharedApplication().openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signup")!)
        }
    }
    
    func showHideActivityIndicator(show: Bool) {
        if show {
            performUIUpdatesOnMain {
                self.activityIndicator.startAnimating()
            }
        } else {
            performUIUpdatesOnMain {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}