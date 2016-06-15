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
                print(session)
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
                    completionHandlerForSession(success: false, session: nil, errorString: NSError(domain: "getSession", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse session"]))
                }
            }
        }
        
    }
    
    
}