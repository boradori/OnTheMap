//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Youngsun Paik on 6/24/16.
//  Copyright © 2016 Youngsun Paik. All rights reserved.
//

import UIKit
import MapKit

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
        Client.sharedInstance().getStudentLocations("100", skip: "10") { (success, results, error) in
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
                performUIUpdatesOnMain {
                    let credentialsAlert = UIAlertController(title: "Cannot download due to bad connectivity", message: "\(error!.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                    credentialsAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(credentialsAlert, animated: true, completion: nil)
                }
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
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                UIApplication.sharedApplication().openURL(NSURL(string: toOpen)!)
            }
        }
    }

}
