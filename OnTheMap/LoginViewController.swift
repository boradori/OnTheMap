//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Youngsun Paik on 6/6/16.
//  Copyright © 2016 Youngsun Paik. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var debugTextLabel: UILabel!
    
    var session: NSURLSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.keyboardType = .EmailAddress
        passwordField.secureTextEntry = true
    }

    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func loginPressed(sender: AnyObject) {
        Client.sharedInstance().authenticateWithViewController(emailField.text!, password: passwordField.text!, hostViewController: self) { (success, sessionID, userID, error, badCredentials) in
            performUIUpdatesOnMain {
                if success {
                    print(sessionID)
                    print(userID)
                    self.completeLogin()
                } else if badCredentials != nil {
                    performUIUpdatesOnMain {
                        let credentialsAlert = UIAlertController(title: "Credential Error", message: "\(badCredentials)", preferredStyle: UIAlertControllerStyle.Alert)
                        credentialsAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(credentialsAlert, animated: true, completion: nil)
                    }
                } else { // Reachability for no internet connection or I could just use error!.localizedDescription for the alert
                    self.appDelegate.statusChangedWithReachability(self.appDelegate.internetReach!)
                }
            }
        }
    }
    
    private func completeLogin() {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("tabBarController") as! UITabBarController
        presentViewController(controller, animated: true, completion: nil)
//        performUIUpdatesOnMain {
//            self.performSegueWithIdentifier("loginSegue", sender: nil)
//        }
    }
}


extension LoginViewController {
    
    private func setUIEnabled(enabled: Bool) {
        loginButton.enabled = enabled
        
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
        
    }
}