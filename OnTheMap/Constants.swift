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
        static let ApiHost = "api.parse.com"
        static let ApiPath = "/1/classes"
        
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
