//
//  StudentInformationModel.swift
//  OnTheMap
//
//  Created by Youngsun Paik on 6/19/16.
//  Copyright © 2016 Youngsun Paik. All rights reserved.
//

import UIKit

class StudentInformationModel {
    
    var studentInformationArray = [StudentInformation]()
    
    class func sharedInstance() -> StudentInformationModel {
        struct Singleton {
            static var sharedInstance = StudentInformationModel()
        }
        return Singleton.sharedInstance
    }
    
}
