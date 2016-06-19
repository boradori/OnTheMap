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
    var userID: String? = nil
    
    
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
    
    func taskForParseGetMethod(method: String, parameters: [String:AnyObject], completionHandlerForGet: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let params = parameters
        
        let request = NSMutableURLRequest(URL: URLFromParameters("Parse", parameters: params, withPathExtension: method))
        request.addValue(Constants.ParseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            guard (error == nil) else {
                print("There is an error with your request")
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status other than 2XX!")
                return
            }
            
            guard let data = data else {
                print("No data was returned with this request")
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGet)
            
        }
        
        task.resume()
        return task
    }
    
    func taskForUdacityPostMethod(jsonBody: String, parameters: [String:AnyObject], completionHandlerForPost: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
//        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        let request = NSMutableURLRequest(URL: URLFromParameters("Udacity", parameters: parameters))
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
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
            
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForPost)
            
        }
        task.resume()
        return task
    }
    
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey: "Could not parse data: '\(data)'"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandlerForConvertData(result: parsedResult, error: nil)
    }
    
    private func URLFromParameters(apiSource: String, parameters: [String:AnyObject], withPathExtension: String? = nil) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = Client.Constants.ApiScheme
        if apiSource == "Udacity" {
            components.host = Client.Constants.ApiHostUdacity
            components.path = Client.Constants.ApiPathUdacity + (withPathExtension ?? "")
        } else if apiSource == "Parse" {
            components.host = Client.Constants.ApiHostParse
            components.path = Client.Constants.ApiPathParse + (withPathExtension ?? "")
        }
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.URL!
    }
    
    
    class func sharedInstance() -> Client {
        struct Singleton {
            static var sharedInstance = Client()
        }
        return Singleton.sharedInstance
    }
    
}