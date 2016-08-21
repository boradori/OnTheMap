//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Youngsun Paik on 6/6/16.
//  Copyright © 2016 Youngsun Paik. All rights reserved.
//

import UIKit
import SafariServices
import FBSDKCoreKit
import FBSDKLoginKit
import XCGLogger

class LoginViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate {
    
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
    
    override func viewDidAppear(animated: Bool) {
        if FBSDKAccessToken.currentAccessToken() != nil {
            completeLogin()
        } else {
            let loginView: FBSDKLoginButton = FBSDKLoginButton()
            loginView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(loginView)
            
            let gapConstraint = NSLayoutConstraint(item: loginView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -20)
            view.addConstraint(gapConstraint)
            
            let horizontalConstraint = NSLayoutConstraint(item: loginView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
            view.addConstraint(horizontalConstraint)
            
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
        }
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
                    log.debug("login button pressed")
                    self.completeLogin()
                    
                } else if badCredentials != nil {
                    self.showHideActivityIndicator(false)
                    self.alertMessage("Credential Error", message: "\(badCredentials)")
                    
                } else if !reachability!.isReachable() { // Reachability for no internet connection or I could just use error!.localizedDescription for the alert
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
//        performUIUpdatesOnMain {
//            UIApplication.sharedApplication().openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signup")!)
//        }
        showWebpage(NSURL(string: "https://www.udacity.com/account/auth#!/signup")!)
    }
    
    private func showWebpage(URL: NSURL) {
        let vc = SFSafariViewController(URL: URL)
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if (error != nil) {
            alertMessage("Error on login", message: "There was an error loggin in via Facebook")
        } else if result.isCancelled {
            alertMessage("Cancel", message: "Cancel Facebook Login")
        } else {
            if result.grantedPermissions.contains("email") {
                alertMessage("Email", message: "You did not grant permission on email")
            } else if result.grantedPermissions.contains("public_profile") {
                alertMessage("Public Profile", message: "You did not grant permission on public profile")
            } else if result.grantedPermissions.contains("user_friends") {
                alertMessage("Friends", message: "You did not grant permission on your friend list")
            }
            returnUserData()
            completeLogin()
        }
    }
    
    func returnUserData() {
        // found graphRequest from http://stackoverflow.com/questions/33186998/facebook-sdk-returns-nil-for-user-first-name-last-name-email-and-username-in-s
        
        let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, email, first_name, last_name"])
        graphRequest.startWithCompletionHandler { (connection, result, error) in
            if (error != nil) {
                self.alertMessage("No data returned", message: "Failed to parse user data")
            } else {
                Client.sharedInstance().firstName = result["first_name"] as! String
                Client.sharedInstance().lastName = result["last_name"] as! String
                Client.sharedInstance().userID = result["id"] as! String
            }
        }
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User logged out")
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