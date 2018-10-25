//
//  PropertiesViewController.swift
//  MyRealEstate
//
//  Created by Raz Friman on 10/20/15.
//  Copyright © 2015 Raz Friman. All rights reserved.
//

import Foundation
import UIKit

class PropertiesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var data = [Property]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Connect the refresh control
        self.tableView.addSubview(self.refreshControl)
        handleRefresh(refreshControl)
        
        // Add a "+" UIBarButtonItem to add a new property
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "handleTableViewAdd:")
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    func handleTableViewAdd(sender: UIBarButtonItem) {
        // Add a new property
        performSegueWithIdentifier("addPropertySegue", sender: self)
    }
    
    // Lazy instaniate a UIRefreshControl for "pull-to-refresh"
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
        }()
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Reload data
        if let userId = ApiManager.sharedInstance.loadFromKeychain(ApiManager.USER_ID_KEY_NAME) {
            
            // Load the user properties
            ApiManager.sharedInstance.loadUserProperties(userId)
                .validate()
                .responseCollection { (_, _, result: Result<[Property]>) in
                    switch(result) {
                    case .Success:
                        
                        if let properties = result.value {
                            self.data = properties
                        }
                        
                        // Reload the table data
                        self.tableView.reloadData()
                        refreshControl.endRefreshing()
                        
                    case .Failure(_, let error):
                        print(error)
                        
                        SCLAlertView().showError("Error", subTitle: "Cannot Load Properties")
                        
                        // Reload the table data
                        self.tableView.reloadData()
                        refreshControl.endRefreshing()
                        
                    }
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Number of properties
        return self.data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let property = data[indexPath.row]
        
        // Load the cell with data
        let cell = tableView.dequeueReusableCellWithIdentifier("propertyCell", forIndexPath: indexPath) as! PropertyCell
        cell.addressLabel.text = property.address
        cell.titleLabel.text = property.title ?? property.address
        cell.leftImageView.image = UIImage(named: "placeholderPropertyIcon")
        
        let progress = Float(arc4random()) / 0xFFFFFFFF
        cell.progressView.setProgress(progress, animated: false)
        
        request(.GET, property.image).response { (request, response, data, error) in
            cell.leftImageView.image = UIImage(data: data!, scale:1)
        }
        
        return cell
    
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Show the property details
        performSegueWithIdentifier("showPropertyDetailSegue", sender: self)
        
        // Deselect the row on the table
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showPropertyDetailSegue") {
            
            // Pass property data to the details page
            let selectedIndex = tableView.indexPathForSelectedRow!.row
            let property = data[selectedIndex]
            let detailVC = segue.destinationViewController as? PropertyDetailViewController
            detailVC?.property = property
        } else if (segue.identifier == "addPropertySegue") {
            // Nothing
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
}