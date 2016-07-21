//
//  Client.swift
//  OnTheMap
//
//  Created by Youngsun Paik on 6/7/16.
//  Copyright © 2016 Youngsun Paik. All rights reserved.
//

import Foundation
import UIKit

class Client: NSObject {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    // shared session
    var session = NSURLSession.sharedSession()
    
    var sessionID: String!
    var userID: String!
    var objectID: String!
    
    var firstName: String!
    var lastName: String!
    
    func taskForParseGetMethod(method: String, parameters: [String:AnyObject], completionHandlerForGet: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let request = NSMutableURLRequest(URL: URLFromParameters("Parse", parameters: parameters, withPathExtension: method))
        request.addValue(Constants.ParseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            guard (error == nil) else {
                print("There is an error with your request PARSE GET METHOD")
                completionHandlerForGet(result: nil, error: error)
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status other than 2XX! taskForParseGetMethod")
                completionHandlerForGet(result: nil, error: NSError(domain: "statusCode", code: 0, userInfo: [NSLocalizedDescriptionKey: "\((response as! NSHTTPURLResponse).statusCode)"]))
                return
            }
            
            guard let data = data else {
                print("No data was returned with this request")
                return
            }
            
            var parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                let userInfo = [NSLocalizedDescriptionKey: "Could not parse data: '\(data)'"]
                completionHandlerForGet(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
                return
            }
            
            completionHandlerForGet(result: parsedResult, error: nil)
        }
        
        task.resume()
        return task
    }
    
    func taskForParsePostMethod(jsonBody: String, method: String, parameters: [String:AnyObject], completionHandlerForPost: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let request = NSMutableURLRequest(URL: URLFromParameters("Parse", parameters: parameters, withPathExtension: method))
        request.HTTPMethod = "POST"
        request.addValue(Constants.ParseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue(Constants.ContentType, forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            guard (error == nil) else {
                print("There is an error with your request: PARSE POST METHOD")
                completionHandlerForPost(result: nil, error: error)
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status other than 2XX! taskForParseGetMethod")
                completionHandlerForPost(result: nil, error: NSError(domain: "statusCode", code: 0, userInfo: [NSLocalizedDescriptionKey: "\((response as! NSHTTPURLResponse).statusCode)"]))
                return
            }
            
            guard let data = data else {
                print("No data was returned with this request")
                return
            }
            
            var parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                let userInfo = [NSLocalizedDescriptionKey: "Could not parse data: '\(data)'"]
                completionHandlerForPost(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
                return
            }
            
            completionHandlerForPost(result: parsedResult, error: nil)
        }
        
        task.resume()
        return task
    }
    
    func taskForParseGetQueryMethod(method: String, parameters: [String:AnyObject], completionHandlerForGetQuery: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let urlString = "https://api.parse.com/1/classes/\(method)?where=%7B%22uniqueKey%22%3A%22\(userID)%22%7D"
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        
        request.addValue(Constants.ParseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            guard (error == nil) else {
                print("There is an error with your request: PARSE GET METHOD")
                completionHandlerForGetQuery(result: nil, error: error)
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status other than 2XX! taskForParseGetMethod")
                completionHandlerForGetQuery(result: nil, error: NSError(domain: "statusCode", code: 0, userInfo: [NSLocalizedDescriptionKey: "\((response as! NSHTTPURLResponse).statusCode)"]))
                return
            }
            
            guard let data = data else {
                print("No data was returned with this request")
                return
            }
            
            var parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                let userInfo = [NSLocalizedDescriptionKey: "Could not parse data: '\(data)'"]
                completionHandlerForGetQuery(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
                return
            }
            
            completionHandlerForGetQuery(result: parsedResult, error: nil)
        }
        
        task.resume()
        return task
        
    }
    
    func taskForParsePutMethod(jsonBody: String, method: String, parameters: [String:AnyObject], completionHandlerForPut: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let request = NSMutableURLRequest(URL: URLFromParameters("Parse", parameters: parameters, withPathExtension: method))
        request.HTTPMethod = "PUT"
        request.addValue(Constants.ParseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue(Constants.ContentType, forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            guard (error == nil) else {
                print("There is an error with your request: PARSE POST METHOD")
                completionHandlerForPut(result: nil, error: error)
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status other than 2XX! taskForParseGetMethod")
                completionHandlerForPut(result: nil, error: NSError(domain: "statusCode", code: 0, userInfo: [NSLocalizedDescriptionKey: "\((response as! NSHTTPURLResponse).statusCode)"]))
                return
            }
            
            guard let data = data else {
                print("No data was returned with this request")
                return
            }
            
            var parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                let userInfo = [NSLocalizedDescriptionKey: "Could not parse data: '\(data)'"]
                completionHandlerForPut(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
                return
            }
            
            completionHandlerForPut(result: parsedResult, error: nil)
        }
        
        task.resume()
        return task
    }
    
    func taskForUdacityGetMethod(parameters: [String:AnyObject], completionHandlerForGet: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let request = NSMutableURLRequest(URL: URLFromParameters("Udacity", parameters: parameters, withPathExtension: Methods.Users + "/" + userID))
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            guard (error == nil) else {
                print("There is an error with your request: UDACITY GET METHOD")
                completionHandlerForGet(result: nil, error: error)
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status other than 2XX! taskForParseGetMethod")
                completionHandlerForGet(result: nil, error: NSError(domain: "statusCode", code: 0, userInfo: [NSLocalizedDescriptionKey: "\((response as! NSHTTPURLResponse).statusCode)"]))
                return
            }
            
            guard let data = data else {
                print("No data was returned with this request.")
                return
            }
            
            /* 5. Parse the data */
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            
            var parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                let userInfo = [NSLocalizedDescriptionKey: "Could not parse data: '\(newData)'"]
                completionHandlerForGet(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
                return
            }
            
            completionHandlerForGet(result: parsedResult, error: nil)
            
        }
        
        task.resume()
        return task
    }
    
    func taskForUdacityPostMethod(jsonBody: String, parameters: [String:AnyObject], completionHandlerForPost: (result: AnyObject!, badCredentials: String!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let request = NSMutableURLRequest(URL: URLFromParameters("Udacity", parameters: parameters, withPathExtension: Methods.Session))
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            guard (error == nil) else {
                print("There is an error with your request: UDACITY POST METHOD")
                completionHandlerForPost(result: nil, badCredentials: nil, error: error)
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status other than 2XX! taskForParseGetMethod")
                completionHandlerForPost(result: nil, badCredentials: nil, error: NSError(domain: "statusCode", code: 0, userInfo: [NSLocalizedDescriptionKey: "\((response as! NSHTTPURLResponse).statusCode)"]))
                return
            }
            
            guard let data = data else {
                print("No data was returned with this request.")
                return
            }
            
            /* 5. Parse the data */
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            
            var parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                let userInfo = [NSLocalizedDescriptionKey: "Could not parse data: '\(newData)'"]
                completionHandlerForPost(result: nil, badCredentials: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
                return
            }
            
            let badCredentials: String? = parsedResult?.valueForKey("error") as? String
            
            completionHandlerForPost(result: parsedResult, badCredentials: badCredentials, error: nil)
            
        }
        task.resume()
        return task
    }
    
    func taskForUdacityDeleteMethod(parameters: [String:AnyObject], completionHandlerForDelete: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let request = NSMutableURLRequest(URL: URLFromParameters("Udacity", parameters: parameters, withPathExtension: Methods.Session))
        
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            guard (error == nil) else {
                print("There is an error with your request: UDACITY DELETE METHOD")
                completionHandlerForDelete(result: nil, error: error)
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status other than 2XX! taskForParseGetMethod")
                completionHandlerForDelete(result: nil, error: NSError(domain: "statusCode", code: 0, userInfo: [NSLocalizedDescriptionKey: "\((response as! NSHTTPURLResponse).statusCode)"]))
                return
            }
            
            guard let data = data else {
                print("No data was returned with this request")
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            //            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            var parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                let userInfo = [NSLocalizedDescriptionKey: "Could not parse data: '\(newData)'"]
                completionHandlerForDelete(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
                return
            }
            print(parsedResult)
            completionHandlerForDelete(result: parsedResult, error: nil)
            
        }
        
        task.resume()
        return task
    }
    
    private func URLFromParameters(apiSource: String, parameters: [String:AnyObject], withPathExtension: String?) -> NSURL {
        
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