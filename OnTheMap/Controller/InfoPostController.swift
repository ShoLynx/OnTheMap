//
//  InfoPostController.swift
//  OnTheMap
//
//  Created by Administrator on 1/9/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class InfoPostController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var infoIcon: UIImageView!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var linkField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    //This button adds users' location and contact link to the UserInfo stored values and progresses to the ConfirmLocationController.
    
    @IBAction func postInfo(_ sender: UIButton) {
        setSendingInfo(true)
        preparePost()
    }
    
    //This allows users to return to the MapViewController
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setSendingInfo(false)
        self.locationField.delegate = self
        self.linkField.delegate = self
    }
    
    //MARK: Controller functions
    //These functions sets users' input to the UserInfo stored values and gets the latitude/longitude information of the location provided.
    
    func preparePost() {
        AppClient.UserInfo.mapString = self.locationField.text!
        AppClient.UserInfo.mediaURL = self.linkField.text ?? ""
            
        self.getGeocode(place: AppClient.UserInfo.mapString) { (success, coordinate) in
            if success {
                let lat = coordinate?.latitude
                let long = coordinate?.longitude
                AppClient.UserInfo.latitude = lat
                AppClient.UserInfo.longitude = long
                let storyboard = UIStoryboard.init(name: "Main", bundle: .main)
                let controller = storyboard.instantiateViewController(withIdentifier: "ConfirmLocationController")
                self.present(controller, animated: true, completion: nil)
            } else {
                self.showGeocodeRetrievalFailue()
            }
        }
    }
    
    func getGeocode (place: String, completion: @escaping (Bool, CLLocationCoordinate2D?) -> () ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(place) { (placemarks, error) -> Void in
            if error != nil {
                print(error!)
                completion(false, nil)
                return
            } else {
                if placemarks!.count > 0 {
                    let placemark = placemarks![0]
                    let location = placemark.location
                    completion(true, location?.coordinate)
                }
            }
        }
    }
    
    //MARK: Error handling
    
    func showGeocodeRetrievalFailue() {
        setSendingInfo(false)
        let alertVC = UIAlertController(title: "Problem Getting Info", message: "Unable to set coordinates.  Please try again later.", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    //This function locks all interactables while network calls are in progress
    
    func setSendingInfo(_ sendingInfo: Bool) {
        if sendingInfo {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        locationField.isEnabled = !sendingInfo
        linkField.isEnabled = !sendingInfo
        findLocationButton.isEnabled = !sendingInfo
        cancelButton.isEnabled = !sendingInfo
        activityIndicator.hidesWhenStopped = true
    }
    
    //Adding Return functionality for the keyboard
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
