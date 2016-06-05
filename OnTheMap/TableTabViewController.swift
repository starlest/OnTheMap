//
//  TableTabViewController.swift
//  OnTheMap
//
//  Created by Edwin Chia on 5/6/16.
//  Copyright © 2016 Edwin Chia. All rights reserved.
//

import UIKit

class TableTabViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: Properties
    
    @IBOutlet weak var pinButton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    let cellReuseIdentifier = "cell"
    @IBOutlet weak var tableView: UITableView!
    
    var activityView: UIActivityIndicatorView!
    
    var studentLocations: [StudentLocation] {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.studentLocations
    }

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpActivityView()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        downloadUserLocations()
    }

    // MARK: Protocols

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier)!
        let studentLocation = studentLocations[indexPath.row]
        cell.textLabel?.text = studentLocation.title
        cell.detailTextLabel?.text = studentLocation.mediaURL
        cell.imageView?.image = UIImage(named: "pin")
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let studentLocation = studentLocations[indexPath.row]
        UIApplication.sharedApplication().openURL(NSURL(string: studentLocation.mediaURL)!)
    }
    
    // MARK: Actions
    
    @IBAction func pinButtonPressed(sender: AnyObject) {
        print(studentLocations.count)
    }

    @IBAction func refreshButtonPressed(sender: AnyObject) {
        downloadUserLocations()
    }
    
    @IBAction func logoutButtonPressed(sender: AnyObject) {
        logout()
    }
}
