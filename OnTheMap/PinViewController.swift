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
    
    @IBOutlet weak var findOnMapButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationTextField.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func findOnMap(sender: AnyObject) {
        findLocation { (coordinates) in
            if let location = coordinates {
                self.displayLocation(location)
            } else {
                print("erorr")
            }
        }
    }
    
    func findLocation(completionHandlerForLocation: (coordinate: CLLocationCoordinate2D?) -> Void) {
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
                
                completionHandlerForLocation(coordinate: nil)
                return
            }
            
            guard let placemark = placemark?.first else {
                completionHandlerForLocation(coordinate: nil)
                return
            }
            
            completionHandlerForLocation(coordinate: placemark.location?.coordinate)
        }
        
    }

    func displayLocation(location: CLLocationCoordinate2D) -> Void {
        let mapView = MKMapView(frame: midView.bounds)
        mapView.zoomEnabled = false
        mapView.scrollEnabled = false
        
        midView.insertSubview(mapView, belowSubview: bottomView)
//        bottomView.alpha = 0.0
//        findOnMapButton.alpha = 1.0
        
        
        let lat = CLLocationDegrees(location.latitude)
        let long = CLLocationDegrees(location.longitude)
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        var annotations = [MKPointAnnotation]()
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotations.append(annotation)
        
        mapView.addAnnotation(annotation)
        mapView.showAnnotations(annotations, animated: true)
        
    }
    
    
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
}