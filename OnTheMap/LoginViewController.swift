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
    
    var session = NSURLSession.sharedSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.keyboardType = .EmailAddress
        passwordField.secureTextEntry = true
        
        emailField.delegate = self
        passwordField.delegate = self
    }

    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func loginPressed(sender: AnyObject) {
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        
        func stopAnimatingActivityIndicator() {
            performUIUpdatesOnMain {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
        }
        
        Client.sharedInstance().authenticateWithViewController(emailField.text!, password: passwordField.text!, hostViewController: self) { (success, sessionID, userID, error, badCredentials) in
            performUIUpdatesOnMain {
                if success {
                    
                    
                    
                    Client.sharedInstance().sessionID = sessionID
                    Client.sharedInstance().userID = userID
                    
                    Client.sharedInstance().getStudentName({ (success, firstName, lastName, error) in
                        if success {
                            Client.sharedInstance().firstName = firstName
                            Client.sharedInstance().lastName = lastName
                        } else {
                            performUIUpdatesOnMain {
                                let noUserInfoAlert = UIAlertController(title: "Error", message: "Failed to get user information", preferredStyle: UIAlertControllerStyle.Alert)
                                noUserInfoAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                                self.presentViewController(noUserInfoAlert, animated: true, completion: nil)
                            }
                        }
                        stopAnimatingActivityIndicator()
                    })
                    self.completeLogin()
                } else if badCredentials != nil {
                    performUIUpdatesOnMain {
                        let credentialsAlert = UIAlertController(title: "Credential Error", message: "\(badCredentials)", preferredStyle: UIAlertControllerStyle.Alert)
                        credentialsAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(credentialsAlert, animated: true, completion: nil)
                    }
                    stopAnimatingActivityIndicator()
                } else if reachabilityStatus == kNOTREACHABLE { // Reachability for no internet connection or I could just use error!.localizedDescription for the alert
                    performUIUpdatesOnMain {
                        let noInternetAlert = UIAlertController(title: "No Internet Connectivity", message: "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.Alert)
                        noInternetAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(noInternetAlert, animated: true, completion: nil)
                    }
                    stopAnimatingActivityIndicator()

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
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}