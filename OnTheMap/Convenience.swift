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
        
        getSessionInfo(email!, password: password!) { success, sessionID, userID, errorString in
            if success {
                self.sessionID = sessionID
                self.userID = userID
                
                self.getStudentLocations({ (success, results, errorString) in
                    if success {
                        
                        StudentInformationModel.sharedInstance().studentInformationArray.removeAll()
                        
                        for studentLocation in results {
                            let studentLocation = StudentInformation(dictionary: studentLocation)
                            
                            StudentInformationModel.sharedInstance().studentInformationArray.append(studentLocation)
                        }
                        
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
    
    
    func getSessionInfo(email: String, password: String, completionHandlerForSessionInfo: (success: Bool, sessionID: String!, userID: String!, errorString: NSError?) -> Void) {
        
        let jsonBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"
        let parameters = [String:AnyObject]()
        
        taskForUdacityPostMethod(jsonBody, parameters: parameters) { (result, error) in
            if let error = error {
                completionHandlerForSessionInfo(success: false, sessionID: nil, userID
                    : nil, errorString: error)
            } else {
                guard let session = result[Client.JSONResponseKeys.Session] as? [String:AnyObject] else {
                    completionHandlerForSessionInfo(success: false, sessionID: nil, userID
                        : nil, errorString: NSError(domain: "getSession session", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse session information"]))
                    return
                }
                
                guard let sessionID = session[Client.JSONResponseKeys.ID] as? String else {
                    completionHandlerForSessionInfo(success: false, sessionID: nil, userID: nil, errorString: NSError(domain: "getSession sessionID", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse sessionID"]))
                    return
                }
                
                guard let account = result[Client.JSONResponseKeys.Account] as? [String:AnyObject] else {
                    completionHandlerForSessionInfo(success: false, sessionID: nil, userID: nil, errorString: NSError(domain: "getSession account", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse account information"]))
                    return
                }
                
                guard let userID = account[Client.JSONResponseKeys.Key] as? String else {
                    completionHandlerForSessionInfo(success: false, sessionID: nil, userID: nil, errorString: NSError(domain: "getSession userID", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse userID"]))
                    return
                }
                

                completionHandlerForSessionInfo(success: true, sessionID: sessionID, userID: userID, errorString: nil)
            }
        }
    }
    
    func getStudentLocations(completionHandlerForStudentLocations: (success: Bool, results: [[String:AnyObject]]!, errorString: NSError?) -> Void) {
        
        let method = Methods.StudentLocation
        let parameters = [String:AnyObject]()
        
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