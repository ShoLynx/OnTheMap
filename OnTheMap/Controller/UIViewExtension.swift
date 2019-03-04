//
//  UIViewExtension.swift
//  OnTheMap
//
//  Created by Administrator on 1/10/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    //Signs out users and returns to the LoginViewController.  This is attached to the Log Off buttons in both MapViewController and StudentTableController
    
    @IBAction func logoutTapped (_ sender: UIBarButtonItem) {
        AppClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
