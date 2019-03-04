//
//  ConfirmLocationController.swift
//  OnTheMap
//
//  Created by Administrator on 1/15/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class ConfirmLocationController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var confirmMap: MKMapView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var goBack: UIBarButtonItem!
    
    //This button allows users to revise the info they provided by backing out to the InfoPostController
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //Calls the AppClient.uploadInfo function to overwrite what is present in the Parse servers with updated location and contact link info

    @IBAction func finish(_ sender: Any) {
        setSendingInfo(true)
        AppClient.uploadInfo(completion: handlePostResponse(success:error:))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSendingInfo(false)
        addAnnotation(place: AppClient.UserInfo.mapString)
    }
    
    //MARK: Annotations info
    
    //latitudeMeters, longitudeMeters and setRegion function utilized to use coordinates value to center and zoom in on users' pin.  Method found on https://stackoverflow.com/questions/277748090/change-initial-zoom-mapkit-swift
    
    func addAnnotation (place: String) {
        
        var annotations = [MKPointAnnotation]()
        let mapString = AppClient.UserInfo.mapString
        let mediaURL = AppClient.UserInfo.mediaURL
        let lat = AppClient.UserInfo.latitude!
        let long = AppClient.UserInfo.longitude!
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let latitudeMeters: CLLocationDistance = 1000000
        let longitudeMeters: CLLocationDistance = 1000000
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: latitudeMeters, longitudinalMeters: longitudeMeters)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = mapString
        annotation.subtitle = mediaURL
        annotations.append(annotation)
                
        confirmMap.addAnnotations(annotations)
        confirmMap.setRegion(region, animated: true)
    }
    
    //MARK: Completion handlers and error alerts
    
    func handlePostResponse(success: Bool, error: Error?) {
        if success {
            setSendingInfo(false)
            let parent = self.presentingViewController
            let grandParent = parent?.presentingViewController
            grandParent?.children.first?.dismiss(animated: true, completion: nil)
        } else {
            setSendingInfo(false)
            showPostFailure(message: error?.localizedDescription ?? "")
            print(error!)
        }
    }
    
    func showPostFailure(message: String) {
        let alertVC = UIAlertController(title: "Post Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    //MARK: MapView delegate function
    
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
    
    //This function locks out all interactables while network calls are in progress
    
    func setSendingInfo(_ sendingInfo: Bool) {
        if sendingInfo {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
        finishButton.isEnabled = !sendingInfo
        goBack.isEnabled = !sendingInfo
        loadingIndicator.hidesWhenStopped = true
    }
    
}
