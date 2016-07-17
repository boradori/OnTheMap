//
//  PinViewController.swift
//  OnTheMap
//
//  Created by Youngsun Paik on 7/14/16.
//  Copyright © 2016 Youngsun Paik. All rights reserved.
//

import UIKit
import MapKit

class PinViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var midView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        
    }
    
    func findLocation(completionHandlerForLocation: (coordinates: CLLocationCoordinate2D?) -> Void) {
        var placemark: CLPlacemark!
//        error!.localizedDescription.containsString("The Internet connection appears to be offline")
        CLGeocoder().geocodeAddressString(locationTextField.text!) { (placemark, error) in
            guard (error == nil) else {
                if reachabilityStatus == kNOTREACHABLE {
                    performUIUpdatesOnMain {
                        let noInternetAlert = UIAlertController(title: "No Internet Connectivity", message: "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.Alert)
                        noInternetAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(noInternetAlert, animated: true, completion: nil)
                    }
                } else {
                    performUIUpdatesOnMain {
                        let locationErrorAlert = UIAlertController(title: "Geocoding Error", message: "Could not find location", preferredStyle: UIAlertControllerStyle.Alert)
                        locationErrorAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(locationErrorAlert, animated: true, completion: nil)
                    }
                }
                
                completionHandlerForLocation(coordinates: nil)
                return
            }
            
            guard let placemark = placemark!.first else {
                completionHandlerForLocation(coordinates: nil)
                return
            }
            
            completionHandlerForLocation(coordinates: placemark.location?.coordinate)
        }

    }
    
    
    
    @IBAction func findOnMap(sender: AnyObject) {
        
    }
    
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
}