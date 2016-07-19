//
//  Constants.swift
//  OnTheMap
//
//  Created by Youngsun Paik on 6/7/16.
//  Copyright © 2016 Youngsun Paik. All rights reserved.
//

extension Client {
    
    struct Constants {
        
        static let ParseAppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ContentType = "application/json"
        
        static let ApiScheme = "https"
        
        static let ApiHostUdacity = "www.udacity.com"
        static let ApiPathUdacity = "/api"
        
        static let ApiHostParse = "api.parse.com"
        static let ApiPathParse = "/1/classes"
        
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let Limit = "limit"
        static let Skip = "skip"
        static let Order = "order"
        
        static let uniqueKey = "uniqueKey"
    }
    
    // MARK: Methods
    struct Methods {
        
        static let Session = "/session"
        static let Users = "/users"
        
        static let StudentLocation = "/StudentLocation"
    }
    
    struct JSONBodyKeys {
        static let objectId = "objectId"
        static let uniqueKey = "uniqueKey"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let latitude = "latitude"
        static let longitude = "longitude"
    }
    
    struct JSONResponseKeys {
        
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        
        static let Session = "session"
        static let ID = "id"
        
        static let Account = "account"
        static let Key = "key"
        
        static let Results = "results"
        
        static let User = "user"
        static let firstName = "first_name"
        static let lastName = "last_name"
        static let objectID = "objectId"
        
        static let updatedAt = "updatedAt"
        
    }
    
}
