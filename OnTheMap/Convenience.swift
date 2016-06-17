//
//  Convenience.swift
//  OnTheMap
//
//  Created by Youngsun Paik on 6/7/16.
//  Copyright © 2016 Youngsun Paik. All rights reserved.
//

import UIKit
import Foundation

extension Client {
    
    func authenticateWithViewController(hostViewController: UIViewController, completionHandlerForAuth: (success: Bool, errorString: NSError?) -> Void) {
        
        getSession(email!, password: password!) { success, session, errorString in
            if success {
                guard let sessionID = session[Client.JSONResponseKeys.ID] as? String else {
                    print("Could not find key in '\(Client.JSONResponseKeys.ID)' in \(session)")
                    return
                }
                self.sessionID = sessionID
                
                self.getAccount(self.email!, password: self.password!
                    , completionHandlerForAccount: { (success, account, errorString) in
                        if success {
                            guard let userID = account[Client.JSONResponseKeys.Key] as? String else {
                                print("Could not find key in '\(Client.JSONResponseKeys.Key)' in \(session)")
                                return
                            }
                            self.userID = Int(userID)
                            completionHandlerForAuth(success: success, errorString: errorString)
                            
                        } else {
                            completionHandlerForAuth(success: success, errorString: errorString)
                        }
                })
            } else {
                completionHandlerForAuth(success: success, errorString: errorString)
            }
        }
        
    }
    
    
    func getSession(email: String, password: String, completionHandlerForSession: (success: Bool, session: [String:AnyObject]!, errorString: NSError?) -> Void) {
        
        let jsonBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"
        
        taskForUdacityPostMethod(jsonBody) { (result, error) in
            if let error = error {
                completionHandlerForSession(success: false, session: nil, errorString: error)
            } else {
                if let session = result[Client.JSONResponseKeys.Session] as? [String:AnyObject] {
                    completionHandlerForSession(success: true, session: session, errorString: nil)
                } else {
                    completionHandlerForSession(success: false, session: nil, errorString: NSError(domain: "getSession", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse session information"]))
                }
            }
        }
        
    }
    
    func getAccount(email: String, password: String, completionHandlerForAccount: (success: Bool, account: [String:AnyObject]!, errorString: NSError?) -> Void) {
        
        let jsonBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"
        
        taskForUdacityPostMethod(jsonBody) { (result, error) in
            if let error = error {
                completionHandlerForAccount(success: false, account: nil, errorString: error)
            } else {
                if let account = result[Client.JSONResponseKeys.Account] as? [String:AnyObject] {
                    completionHandlerForAccount(success: true, account: account, errorString: nil)
                } else {
                    completionHandlerForAccount(success: false, account: nil, errorString: NSError(domain: "getAccount", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse account information"]))
                }
            }
        }
    }
    
    
}