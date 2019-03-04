//
//  StudentTableCellController.swift
//  OnTheMap
//
//  Created by Administrator on 1/10/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit

class StudentTableCellController: UITableViewCell {
    
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var studentLink: UILabel!
    @IBOutlet weak var locationIcon: UIImageView!
    
    //This models the prototype cell's layout.
    
    func configure(with model: StudentLocation) {
        let firstName = model.firstName
        let lastName = model.lastName
        studentName.text = (firstName ?? "") + ", " + (lastName ?? "")
        studentLink.text = model.mediaURL
    }
}
