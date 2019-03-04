//
//  StudentTableController.swift
//  OnTheMap
//
//  Created by Administrator on 1/9/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit

class StudentTableController: UITableViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    
    var selectedIndex = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh(self)
    }
    
    // This calls AppClient.getStudentLocation to get the latest set of 100 StudentLocation items and reloads the tableView.
    
    @IBAction func refresh(_ sender: Any) {
        AppClient.getStudentLocation(completion: handleSearchResponse(pool:error:))
    }
    
    //MARK: Error handling
    
    func showSearchFailure(message: String) {
        let alertVC = UIAlertController(title: "Problem Getting Info", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    func handleSearchResponse (pool: [StudentLocation]?, error: Error?) {
        if pool != nil {
            tableView!.reloadData()
        } else {
            print(error!)
        }
    }
    
    //MARK: Table delegate functions
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MapPool.results.count
    }
    
    //This function controls how information is displayed in each cell.  It is currently set up with names displayed last name first, with the contact link students provide as the cell's subtitle.
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableCellController")!
        
        let searchResult = MapPool.results[indexPath.row]
        
        cell.textLabel?.text = "\(searchResult.lastName ?? ""), \(searchResult.firstName ?? "")"
        cell.detailTextLabel?.text = "\(searchResult.mediaURL ?? "")"
        
        return cell
    }
    
    //This function allows each cell to open a Safari browser window to the selected student's contact link (mediaURL).  mediaURLs without 'http' or 'https' will have it added to the mediaURL, so that the browser will open with the mediaURL.  The browser will only fail to open if mediaURL is blank.
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        let searchResult = MapPool.results[indexPath.row]
        let url = URL(string: searchResult.mediaURL ?? "")
        let altURL = "http://" + (searchResult.mediaURL ?? "")
        let httpURL = URL(string: altURL)
        if (searchResult.mediaURL != nil && searchResult.mediaURL != "") && (searchResult.mediaURL!.contains("http://") || searchResult.mediaURL!.contains("https://")) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            tableView.deselectRow(at: indexPath, animated: true)
        } else if (searchResult.mediaURL != nil && searchResult.mediaURL != "") {
            UIApplication.shared.open(httpURL!, options: [:], completionHandler: nil)
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            return
        }
    }

}
