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
    
    func getStudentName(completionHandlerForName: (success: Bool, firstName: String!, lastName: String!, error: NSError?) -> Void) {
        
        let parameters = [String:AnyObject]()
        
        taskForUdacityGetMethod(parameters) { (result, error) in
            guard (error == nil) else {
                print(error)
                completionHandlerForName(success: false, firstName: nil, lastName: nil, error: error)
                return
            }
            
            guard let user = result[Client.JSONResponseKeys.User] as? [String:AnyObject] else {
                completionHandlerForName(success: false, firstName: nil, lastName: nil, error: error)
                return
            }
            
            guard let firstName = user[Client.JSONResponseKeys.firstName] as? String else {
                completionHandlerForName(success: false, firstName: nil, lastName: nil, error: error)
                return
            }
            
            guard let lastName = user[Client.JSONResponseKeys.lastName] as? String else {
                completionHandlerForName(success: false, firstName: nil, lastName: nil, error: error)
                return
            }
            
            completionHandlerForName(success: true, firstName: firstName, lastName: lastName, error: nil)
        }
        
    }
    
    func queryStudentLocation(userID: String, completionHandlerForQueryingStudentLocation: (duplicated: Bool, error: NSError?) -> Void) {
        
        let method = Methods.StudentLocation + "?where=%7B%22" + "\(Client.ParameterKeys.uniqueKey)" + "%22%3A%22" + "\(userID)" + "%22%7D"
        let parameters = [String:AnyObject]()
        
        taskForParseGetQueryMethod(method, parameters: parameters) { (results, error) in
            if let error = error {
                completionHandlerForQueryingStudentLocation(duplicated: false, error: error)
            } else {
                guard let results = results[Client.JSONResponseKeys.Results] as? [[String:AnyObject]] else {
                    completionHandlerForQueryingStudentLocation(duplicated: false, error: NSError(domain: "results", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse query results"]))
                    return
                }

                // Find a result that has uniqueKey of userID
                for result in results {
                    if result["uniqueKey"] as! String == userID {
                        // Set client's objectID eqaul to the first result's objectID
                        // This objectID is used to updateStudentLocation
                        Client.sharedInstance().objectID = results.first![JSONResponseKeys.objectID] as? String
                    }
                }
                
                completionHandlerForQueryingStudentLocation(duplicated: true, error: nil)
            }
        }
        
    }
    
    
    func addStudentLocation(studentInformation: StudentInformation, completionHandlerForAddingStudentLocation: (success: Bool, objectID: String?, error: NSError?) -> Void) {
        
        let jsonBody = "{\"uniqueKey\": \"\(studentInformation.uniqueKey!)\", \"firstName\": \"\(studentInformation.firstName!)\", \"lastName\": \"\(studentInformation.lastName!)\",\"mapString\": \"\(studentInformation.mapString!)\", \"mediaURL\": \"\(studentInformation.mediaURL!)\",\"latitude\": \(studentInformation.latitude!), \"longitude\": \(studentInformation.longitude!)}"
        
        let method = Methods.StudentLocation
        let parameters = [String:AnyObject]()
        
        taskForParsePostMethod(jsonBody, method: method, parameters: parameters) { (result, error) in
            if let error = error {
                completionHandlerForAddingStudentLocation(success: false, objectID: nil, error: error)
            } else {
                print(result)
                guard let objectID = result[Client.JSONResponseKeys.objectID] as? String else {
                    completionHandlerForAddingStudentLocation(success: false, objectID: nil, error: NSError(domain: "objectID", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse objectID"]))
                    return
                }
                completionHandlerForAddingStudentLocation(success: true, objectID: objectID, error: nil)
            }
        }
    }
    
    func updateStudentLocation(objectID: String, studentInformation: StudentInformation, completionHandlerForupdatingStudentLocation: (success: Bool, updatedAt: String?, error: NSError?) -> Void) {
        
        let jsonBody = "{\"uniqueKey\": \"\(studentInformation.uniqueKey!)\", \"firstName\": \"\(studentInformation.firstName!)\", \"lastName\": \"\(studentInformation.lastName!)\",\"mapString\": \"\(studentInformation.mapString!)\", \"mediaURL\": \"\(studentInformation.mediaURL!)\",\"latitude\": \(studentInformation.latitude!), \"longitude\": \(studentInformation.longitude!)}"
        
        let method = Methods.StudentLocation + "/" + objectID
        let parameters = [String:AnyObject]()
        
        taskForParsePutMethod(jsonBody, method: method, parameters: parameters) { (result, error) in
            if let error = error {
                print(error)
                completionHandlerForupdatingStudentLocation(success: false, updatedAt: nil, error: error)
            } else {
                print(result)
                guard let updatedAt = result[Client.JSONResponseKeys.updatedAt] as? String else {
                    completionHandlerForupdatingStudentLocation(success: false, updatedAt: nil, error: NSError(domain: "updatedAt", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse updatedAt"]))
                    return
                }
                completionHandlerForupdatingStudentLocation(success: true, updatedAt: updatedAt, error: nil)
            }
        }
        
    }
    
    
    
    func getStudentLocations(limit: String, completionHandlerForGettingStudentLocations: (success: Bool, results: [[String:AnyObject]]!, error: NSError?) -> Void) {
        
        let method = Methods.StudentLocation
        let parameters = [Client.ParameterKeys.Limit: limit, Client.ParameterKeys.Order: "-updatedAt"]
        
        print(parameters)
        
        taskForParseGetMethod(method, parameters: parameters) { (result, error) in
            if let error = error {
                completionHandlerForGettingStudentLocations(success: false, results: nil, error: error)
            } else {
                guard let results = result[Client.JSONResponseKeys.Results] as? [[String:AnyObject]] else {
                    completionHandlerForGettingStudentLocations(success: false, results: nil, error: NSError(domain: "getStudentLocation", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse student locations"]))
                    return
                }
                completionHandlerForGettingStudentLocations(success: true, results: results, error: nil)
            }
        }
    }
    
    func logoutFromUdacity(completionHandlerForLogoutFromUdacity: (success: Bool, results: [String:AnyObject]!, error: NSError?) -> Void) {
        
        let parameters = [String:AnyObject]()
        
        taskForUdacityDeleteMethod(parameters) { (result, error) in
            if let error = error {
                completionHandlerForLogoutFromUdacity(success: false, results: nil, error: error)
            } else {
                guard let results = result[Client.JSONResponseKeys.Session] as? [String:AnyObject] else {
                    completionHandlerForLogoutFromUdacity(success: false, results: nil, error: NSError(domain: "logoutFromUdacity", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse logout result"]))
                    return
                }
                completionHandlerForLogoutFromUdacity(success: true, results: results, error: nil)
            }
        }
    }
}