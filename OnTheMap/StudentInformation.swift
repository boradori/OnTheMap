//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Youngsun Paik on 6/17/16.
//  Copyright © 2016 Youngsun Paik. All rights reserved.
//

import UIKit

struct StudentInformation {
    
    var objectId: String? = nil
    var uniqueKey: String? = nil // Udacity userID
    var firstName: String? = nil
    var lastName: String? = nil
    var mapString: String? = nil
    var mediaURL: String? = nil
    var latitude: Double? = nil
    var longitude: Double? = nil
    

    init(dictionary: [String:AnyObject]) {
        
        objectId = dictionary[Client.JSONBodyKeys.objectId] as? String
        uniqueKey = dictionary[Client.JSONBodyKeys.uniqueKey] as? String
        firstName = dictionary[Client.JSONBodyKeys.firstName] as? String
        lastName = dictionary[Client.JSONBodyKeys.lastName] as? String
        mapString = dictionary[Client.JSONBodyKeys.mapString] as? String
        mediaURL = dictionary[Client.JSONBodyKeys.mediaURL] as? String
        latitude = dictionary[Client.JSONBodyKeys.latitude] as? Double
        longitude = dictionary[Client.JSONBodyKeys.longitude] as? Double
        
    }
    
}