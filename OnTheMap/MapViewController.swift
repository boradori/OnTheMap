//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Youngsun Paik on 6/24/16.
//  Copyright © 2016 Youngsun Paik. All rights reserved.
//

import UIKit
import MapKit
import FBSDKCoreKit
import FBSDKLoginKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loadStudentInformation()
    }
    
    func loadStudentInformation() {
        Client.sharedInstance().getStudentLocations("100") { (success, results, error) in
            if success {
                
                // Create an MKPointAnnocation for each dictionary in studentLocation.
                var annotations = [MKPointAnnotation]()
                
                // Remove elements in annotations array before loading annotations again
                performUIUpdatesOnMain {
                    self.mapView.removeAnnotations(self.mapView.annotations)
                }
                
                for studentLocation in results {
                    //
                    let lat = CLLocationDegrees(studentLocation[Client.JSONBodyKeys.latitude] as! Double)
                    let long = CLLocationDegrees(studentLocation[Client.JSONBodyKeys.longitude] as! Double)
                    
                    // The lat and long are used to create a CLLocationCoordinates2D instance.
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let first = studentLocation[Client.JSONBodyKeys.firstName] as! String
                    let last = studentLocation[Client.JSONBodyKeys.lastName] as! String
                    let mediaURL = studentLocation[Client.JSONBodyKeys.mediaURL] as! String
                    
                    // Here we create the annotation and set its coordiate, title, and subtitle properties
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    
                    // Finally we place the annotation in an array of annotations.
                    annotations.append(annotation)
                }
                performUIUpdatesOnMain {
                    self.mapView.addAnnotations(annotations)
                }
                
            } else {
                self.alertMessage("Cannot download due to bad connectivity", message: "\(error!.localizedDescription)")
            }
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let app = UIApplication.sharedApplication()
        if control == view.rightCalloutAccessoryView {
            // check for nil
            if let toOpen = view.annotation?.subtitle! {
                // create NSURL instance
                if let url = NSURL(string: toOpen) {
                    // check if your application can open the NSURL instance
                    if app.canOpenURL(url) {
                        app.openURL(url)
                    } else {
                        self.alertMessage("Error", message: "Invalid URL")
                    }
                }
            }
        }
    }
    
    @IBAction func refresh(sender: AnyObject) {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        
        func stopAnimatingActivityIndicator() {
            performUIUpdatesOnMain {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
        }
        
        loadStudentInformation()
        stopAnimatingActivityIndicator()
    }
    
    @IBAction func logout(sender: AnyObject) {
        FBSDKLoginManager().logOut()
        Client.sharedInstance().logoutFromUdacity { (success, results, error) in
            if success {
                performUIUpdatesOnMain {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            } else {
                self.alertMessage("Cannot logout", message: "\(error!.localizedDescription)")
            }
        }
    }
    
}
