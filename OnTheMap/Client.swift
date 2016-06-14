//
//  Client.swift
//  OnTheMap
//
//  Created by Youngsun Paik on 6/7/16.
//  Copyright © 2016 Youngsun Paik. All rights reserved.
//

import Foundation

class Client: NSObject {
    
    
    
    // shared session
    var session = NSURLSession.sharedSession()
    
    var email: String? = nil
    var password: String? = nil
    
    // authenticate state
    var sessionID: String? = nil
    var userID: Int? = nil
    
    
//    private func userData() {
//        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/3903878747")!)
//        let session = NSURLSession.sharedSession()
//        let task = session.dataTaskWithRequest(request) { data, response, error in
//            if error != nil { // Handle error...
//                return
//            }
//            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
//            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
//        }
//        task.resume()
//    }
    
    
    
    func getSessionID() {
        
        /* TASK: Get a session ID, then store it (appDelegate.sessionID) and get the user's id */
        
        /* 1. Set the parameters */
        
        

        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(email!)\", \"password\": \"\(password!)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        /* 4. Make the request */
        
        let task = session.dataTaskWithRequest(request) {
            data, response, error in
            
            
            guard (error == nil) else {
                print("There is an error with your request")
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status other than 2XX!")
                return
            }
            
            guard let data = data else {
                print("No data was returned with this request.")
                return
            }
            
            /* 5. Parse the data */
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
//            print(newData)
            
//            print(NSString(data: newData, encoding: NSUTF8StringEncoding)!)
            
            let parsedResult: AnyObject!
            
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                print("Could not parse data")
                return
            }
            print(parsedResult)
            
            guard let session = parsedResult[Client.JSONResponseKeys.Session] as? [String:AnyObject] else {
                print("Could not find keys '\(Client.JSONResponseKeys.Session)' in \(parsedResult)")
                return
            }
            
            print(session)
            
            guard let sessionID = session[Client.JSONResponseKeys.ID] as? String else {
                print("Could not find keys '\(Client.JSONResponseKeys.ID)' in \(session)")
                return
            }
            
            self.sessionID = sessionID

        }
        
        /* 7. Start the request */
        task.resume()
        
    }
    
    class func sharedInstance() -> Client {
        struct Singleton {
            static var sharedInstance = Client()
        }
        return Singleton.sharedInstance
    }
    
}