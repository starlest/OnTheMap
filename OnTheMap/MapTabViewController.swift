//
//  MapTabViewController.swift
//  OnTheMap
//
//  Created by Edwin Chia on 3/6/16.
//  Copyright © 2016 Edwin Chia. All rights reserved.
//

import UIKit
import MapKit

class MapTabViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logoutButtonPressed(sender: AnyObject) {
        Client.sharedInstance().showLogoutConfirmationAlert(hostController: self) { (flag) in
            if flag {
                Client.sharedInstance().attemptToEndSession({ (success, error) in
                    if success {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                })
            }
        }
    }
    
    @IBAction func pinButtonPressed(sender: AnyObject) {
    }
    
    @IBAction func refreshButtonPressed(sender: AnyObject) {
    }
}
