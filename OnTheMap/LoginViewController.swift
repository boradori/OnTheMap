//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Youngsun Paik on 6/6/16.
//  Copyright © 2016 Youngsun Paik. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
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
        debugTextLabel.text = ""
    }
    
    @IBAction func loginPressed(sender: AnyObject) {
        Client.sharedInstance().authenticateWithViewController(emailField.text!, password: passwordField.text!, hostViewController: self) { (success, sessionID, userID, error) in
            performUIUpdatesOnMain {
                if success {
                    print(sessionID)
                    print(userID)
                    self.completeLogin()
                } else {
                    self.displayError("Error: need to implement Reachability to display proper error message")
                }
            }
        }
    }
    
    private func completeLogin() {
        debugTextLabel.text = ""
        let controller = storyboard!.instantiateViewControllerWithIdentifier("ManagerNavigationController") as! UINavigationController
        presentViewController(controller, animated: true, completion: nil)
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
    
    private func displayError(errorString: String?) {
        if let errorString = errorString {
            debugTextLabel.text = errorString
        }
    }
    
}