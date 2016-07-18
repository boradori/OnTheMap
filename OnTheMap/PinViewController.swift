//
//  PinViewController.swift
//  OnTheMap
//
//  Created by Youngsun Paik on 7/14/16.
//  Copyright © 2016 Youngsun Paik. All rights reserved.
//

import UIKit
import MapKit

class PinViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var midView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var locationTextView: UITextView!
    @IBOutlet weak var mediaURLTextView: UITextView!
    
    @IBOutlet weak var findOnMapButton: UIButton!
    
    var newStudentLocation: Bool!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationTextView.delegate = self
        mediaURLTextView.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        mediaURLTextView.editable = false
        findOnMapButton.setTitle("Find on the Map", forState: .Normal)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"  // Recognizes enter key in keyboard
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        locationTextView.text = ""
        if findOnMapButton.currentTitle == "Submit" {
            mediaURLTextView.text = ""
        }
    }
    
    
    @IBAction func findOnMap(sender: AnyObject) {
        if findOnMapButton.currentTitle == "Find on the Map" {
            findLocation({ (coordinate) in
                guard let location = coordinate else {
                    print("There is an error with your request: findLocation")
                    return
                }
                
                self.bottomView.alpha = 0.5
                self.findOnMapButton.setTitle("Submit", forState: .Normal)
                self.displayLocation(location)
                
                // let user enter URL
                self.mediaURLTextView.editable = true
                self.mediaURLTextView.text = "Enter a Link to Share Here"
                
            })
        } else {
            
//            topViewLabel.text = "Enter a Link to Share Here"
            
            // Send location and URL through submit using parse post method
            
            
            
            
        }

    }
    
    func findLocation(completionHandlerForLocation: (coordinate: CLLocationCoordinate2D?) -> Void) {
        CLGeocoder().geocodeAddressString(locationTextView.text!) { (placemark, error) in
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