//
//  AlertMessages.swift
//  OnTheMap
//
//  Created by Youngsun Paik on 7/20/16.
//  Copyright © 2016 Youngsun Paik. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func alertMessage(title: String, message: String) {
        performUIUpdatesOnMain {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
}