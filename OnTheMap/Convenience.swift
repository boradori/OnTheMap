//
//  Convenience.swift
//  OnTheMap
//
//  Created by Youngsun Paik on 6/7/16.
//  Copyright © 2016 Youngsun Paik. All rights reserved.
//

import UIKit
import Foundation
import MapKit

extension Client {
    
    func authenticateWithViewController(email: String, password: String, hostViewController: UIViewController, completionHandlerForAuth: (success: Bool, sessionID: String!, userID: String!, error: NSError?, badCredentials: String!) -> Void) {
        
        let jsonBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"
        let parameters = [String:AnyObject]()
        
        taskForUdacityPostMethod(jsonBody, parameters: parameters) { (result, badCredentials, error) in
            if let error = error {
                print(error)
                completionHandlerForAuth(success: false, sessionID: nil, userID: nil, error: error, badCredentials: nil)
            } else if badCredentials != nil {
                completionHandlerForAuth(success: false, sessionID: nil, userID: nil, error: nil, badCredentials: badCredentials)
            } else {
                guard let session = result[Client.JSONResponseKeys.Session] as? [String:AnyObject] else {
                    completionHandlerForAuth(success: false, sessionID: nil, userID: nil, error: error, badCredentials: nil)
                    return
                }
                
                guard let sessionID = session[Client.JSONResponseKeys.ID] as? String else {
                    completionHandlerForAuth(success: false, sessionID: nil, userID: nil, error: error, badCredentials: nil)
                    return
                }
                
                guard let account = result[Client.JSONResponseKeys.Account] as? [String:AnyObject] else {
                    completionHandlerForAuth(success: false, sessionID: nil, userID: nil, error: error, badCredentials: nil)
                    return
                }
                
                guard let userID = account[Client.JSONResponseKeys.Key] as? String else {
                    completionHandlerForAuth(success: false, sessionID: nil, userID: nil, error: error, badCredentials: nil)
                    return
                }
                
                completionHandlerForAuth(success: true, sessionID: sessionID, userID: userID, error: nil, badCredentials: nil)
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