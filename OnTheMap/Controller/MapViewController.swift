//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Administrator on 1/9/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var studentMap: MKMapView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addAnnotation(data: MapPool.results)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh(self)
    }
    
    // This calls AppClient.getStudentLocation to get the latest set of 100 StudentLocation items
    
    @IBAction func refresh(_ sender: Any) {
        AppClient.getStudentLocation(completion: handleSearchResponse(pool:error:))
        studentMap.reloadInputViews()
    }
    
    
    //MARK: Annotation Data - This lists the relevant information to display for a StudentLocation item and lists how a pin annotation will display that data
    
    
    func addAnnotation(data: [StudentLocation]) {
        let locations = data
        var annotations = [MKPointAnnotation]()
        for dictionary in locations {
            if dictionary.latitude != nil && dictionary.longitude != nil {
                let lat = CLLocationDegrees(dictionary.latitude!)
                let long = CLLocationDegrees(dictionary.longitude!)
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                let first = dictionary.firstName
                let last = dictionary.lastName
                let mediaURL = dictionary.mediaURL
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(last ?? ""), \(first ?? "")"
                annotation.subtitle = mediaURL
                annotations.append(annotation)
            }
        }
        studentMap.addAnnotations(annotations)
    }
    
    //MARK: Completion handler and error handling functions for the getStudentLocation function used to get the Pin info
    
    func handleSearchResponse (pool: [StudentLocation]?, error: Error?) {
        if pool != nil {
            addAnnotation(data: MapPool.results)
        } else {
            print(error!)
        }
    }
    
    func showSearchFailure(message: String) {
        let alertVC = UIAlertController(title: "Problem Getting Info", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    //MARK: Map delegate functions
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.tintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    //This function allows each annotation to open a Safari browser window to the selected student's contact link (mediaURL).  mediaURLs without 'http' or 'https' will have it added to the mediaURL, so that the browser will open with the mediaURL.  The browser will only fail to open if mediaURL is blank.
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            let toOpen = view.annotation?.subtitle!
            let url = URL(string: toOpen ?? "")
            let altURL = "http://" + toOpen!
            let httpURL = URL(string: altURL)
            if (toOpen != nil && toOpen != "") && (toOpen!.contains("http://") || toOpen!.contains("https://")) {
                app.open(url!, options: [:], completionHandler: nil)
            } else if (toOpen != nil && toOpen != "") {
                app.open(httpURL!, options: [:], completionHandler: nil)
            } else {
                return
            }
        }
    }

}
