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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var newStudentLocation: Bool!
    
    var locationString: String!
    var userLocation: CLLocationCoordinate2D!
    
    
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
    
    // Dismissing keyboard with return
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
            
            locationString = locationTextView.text
            
            self.showHideActivityIndicator(true)
            
            // Find location using CLGeocoder
            findLocation(locationString, completionHandlerForLocation: { (coordinate) in
                guard let location = coordinate else {
                    print("There is an error with your request: findLocation")
                    self.showHideActivityIndicator(false)
                    return
                }
                
                self.userLocation = location
                
                self.bottomView.alpha = 0.5
                
                self.findOnMapButton.setTitle("Submit", forState: .Normal)
                
                // Display the location on map
                self.displayLocation(location)
                
                self.showHideActivityIndicator(false)
                
                // let user enter URL
                self.mediaURLTextView.editable = true
                self.mediaURLTextView.text = "Enter a Link to Share Here"
            })
        } else if findOnMapButton.currentTitle == "Submit" {
            
            self.showHideActivityIndicator(true)
            
            if self.mediaURLTextView.text == "Enter a Link to Share Here" {
                self.alertMessage("Invalid URL", message: "Please enter valid URL")
                
            } else if self.mediaURLTextView.text != "" {
                // Send location and URL through submit using parse post method
                
                var newStudentInformation = [String:AnyObject]()
                newStudentInformation[Client.JSONBodyKeys.uniqueKey] = Client.sharedInstance().userID
                newStudentInformation[Client.JSONBodyKeys.firstName] = Client.sharedInstance().firstName
                newStudentInformation[Client.JSONBodyKeys.lastName] = Client.sharedInstance().lastName
                newStudentInformation[Client.JSONBodyKeys.mapString] = locationString
                newStudentInformation[Client.JSONBodyKeys.mediaURL] = mediaURLTextView.text
                newStudentInformation[Client.JSONBodyKeys.latitude] = userLocation.latitude
                newStudentInformation[Client.JSONBodyKeys.longitude] = userLocation.longitude
                
                let studentInfo = StudentInformation(dictionary: newStudentInformation)
                
                Client.sharedInstance().queryStudentLocation(Client.sharedInstance().userID, completionHandlerForQueryingStudentLocation: { (duplicated, error) in
                    if duplicated {
                        Client.sharedInstance().updateStudentLocation(Client.sharedInstance().objectID, studentInformation: studentInfo, completionHandlerForupdatingStudentLocation: { (success, updatedAt, error) in
                            if success {
                                print(updatedAt)
                                self.dismissViewControllerAnimated(true, completion: nil)
                            } else {
                                self.alertMessage("Updating Student Error", message: "Please enter valid URL")
                            }
                            self.showHideActivityIndicator(false)
                        })
                    } else if duplicated == false {
                        Client.sharedInstance().addStudentLocation(studentInfo, completionHandlerForAddingStudentLocation: { (success, objectID, error) in
                            if success {
                                Client.sharedInstance().objectID = objectID
                                self.dismissViewControllerAnimated(true, completion: nil)
                            } else {
                                self.alertMessage("Adding Student Error", message: "Please enter valid URL")
                            }
                            self.showHideActivityIndicator(false)
                        })
                    } else if reachabilityStatus == kNOTREACHABLE {
                        self.alertMessage("No Internet Connectivity", message: "Make sure your device is connected to the internet")
                        self.showHideActivityIndicator(false)
                    } else {
                        self.alertMessage("Geocoding Error", message: "\(error!.localizedDescription)")
                        self.showHideActivityIndicator(false)
                    }
                })
                
            } else {
                self.alertMessage("Invalid URL", message: "Please enter valid URL")
            }
        }
    }
    
    func findLocation(location: String, completionHandlerForLocation: (coordinate: CLLocationCoordinate2D?) -> Void) {
        CLGeocoder().geocodeAddressString(location) { (placemark, error) in
            guard (error == nil) else {
                if reachabilityStatus == kNOTREACHABLE {
                    self.alertMessage("No Internet Connectivity", message: "Make sure your device is connected to the internet")
                } else if location == "Enter Your Location Here" {
                    self.alertMessage("You did not enter location", message: "Please enter valid location information")
                } else if location == ""{
                    self.alertMessage("You did not enter location", message: "Please enter valid location information")
                } else {
                    self.alertMessage("Geocoding Error", message: "\(error!.localizedDescription)")
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
        
        // Previous code reviewer suggested these 3 lines for more appropriate zoom level but I do not see any difference.
        // Is it because I disabled zoom?
        let span = MKCoordinateSpanMake(5, 5)
        let region = MKCoordinateRegionMake(location, span)
        mapView.setRegion(region, animated: true)
        
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
    
    func showHideActivityIndicator(show: Bool) {
        if show {
            performUIUpdatesOnMain {
                self.activityIndicator.startAnimating()
            }
        } else {
            performUIUpdatesOnMain {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
}