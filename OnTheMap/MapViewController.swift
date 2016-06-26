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
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        loadStudentInformation()
    }
    
    func loadStudentInformation() {
        Client.sharedInstance().getStudentLocations("100", skip: "10") { (success, results, errorString) in
            if success {
                
                performUIUpdatesOnMain {
                    self.mapView.removeAnnotations(self.mapView.annotations)
                }
                
                // Create an MKPointAnnocation for each dictionary in studentLocation.
                var annotations = [MKPointAnnotation]()
                
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
                
            }
        }
    }
    
}
