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
    
    func authenticateWithViewController(hostViewController: UIViewController, completionHandlerForAuth: (success: Bool, errorString: String?) -> Void) {
        
        getSessionInfo(email!, password: password!) { success, sessionID, userID, errorString in
            if success {
                self.sessionID = sessionID
                self.userID = userID
                completionHandlerForAuth(success: success, errorString: errorString)
            } else {
                completionHandlerForAuth(success: success, errorString: errorString)
            }
        }
    }

    
    func getSessionInfo(email: String, password: String, completionHandlerForSessionInfo: (success: Bool, sessionID: String!, userID: String!, errorString: String?) -> Void) {
        
        let jsonBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"
        let parameters = [String:AnyObject]()
        
        taskForUdacityPostMethod(jsonBody, parameters: parameters) { (result, error) in
            if let error = error {
                print(error)
                completionHandlerForSessionInfo(success: false, sessionID: nil, userID
                    : nil, errorString: "Login failed (session)")
            } else {
                guard let session = result[Client.JSONResponseKeys.Session] as? [String:AnyObject] else {
                    completionHandlerForSessionInfo(success: false, sessionID: nil, userID
                        : nil, errorString: "Login failed (session)")
                    return
                }
                
                guard let sessionID = session[Client.JSONResponseKeys.ID] as? String else {
                    completionHandlerForSessionInfo(success: false, sessionID: nil, userID: nil, errorString: "Login failed (sessionID)")
                    return
                }
                
                guard let account = result[Client.JSONResponseKeys.Account] as? [String:AnyObject] else {
                    completionHandlerForSessionInfo(success: false, sessionID: nil, userID: nil, errorString: "Login failed (account)")
                    return
                }
                
                guard let userID = account[Client.JSONResponseKeys.Key] as? String else {
                    completionHandlerForSessionInfo(success: false, sessionID: nil, userID: nil, errorString: "Login failed (userID)")
                    return
                }
                

                completionHandlerForSessionInfo(success: true, sessionID: sessionID, userID: userID, errorString: nil)
            }
        }
    }
    
    func getStudentLocations(limit: String, skip: String, completionHandlerForStudentLocations: (success: Bool, results: [[String:AnyObject]]!, errorString: NSError?) -> Void) {
        
        let method = Methods.StudentLocation
        let parameters = [Client.ParameterKeys.Limit: limit, Client.ParameterKeys.Skip: skip, Client.ParameterKeys.Order: "-updatedAt"]
        print(parameters)
        
        taskForParseGetMethod(method, parameters: parameters) { (result, error) in
            if let error = error {
                completionHandlerForStudentLocations(success: false, results: nil, errorString: error)
            } else {
                guard let results = result[Client.JSONResponseKeys.Results] as? [[String:AnyObject]] else {
                    completionHandlerForStudentLocations(success: false, results: nil, errorString: NSError(domain: "getStudentLocation", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse student locations"]))
                    return
                }
                completionHandlerForStudentLocations(success: true, results: results, errorString: nil)
            }
        }
    }
    
}