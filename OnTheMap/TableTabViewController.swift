//
//  TableTabViewController.swift
//  OnTheMap
//
//  Created by Edwin Chia on 5/6/16.
//  Copyright © 2016 Edwin Chia. All rights reserved.
//

import UIKit

class TableTabViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var pinButton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    var activityView: UIActivityIndicatorView!
    
    var studentLocations: [StudentLocation] {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.studentLocations
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func pinButtonPressed(sender: AnyObject) {
    }

    @IBAction func refreshButtonPressed(sender: AnyObject) {
    }
    
    @IBAction func logoutButtonPressed(sender: AnyObject) {
    }
}
