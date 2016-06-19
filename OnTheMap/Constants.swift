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
        
        static let ApiScheme = "https"
        
        static let ApiHostUdacity = "www.udacity.com"
        static let ApiPathUdacity = "/api/session"
        
        static let ApiHostParse = "api.parse.com"
        static let ApiPathParse = "/1/classes"
        
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let Limit = "limit"
        static let Skip = "skip"
        static let Order = "order"
        
    }
    
    // MARK: Methods
    struct Methods {
        static let StudentLocation = "/StudentLocation"
    }
    
    struct JSONResponseKeys {
        
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        
        static let Session = "session"
        static let ID = "id"
        
        static let Account = "account"
        static let Key = "key"
    }
    
}
