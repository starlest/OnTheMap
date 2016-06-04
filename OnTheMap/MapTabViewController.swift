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
        Client.showLogoutConfirmationAlert(hostController: self) { (flag) in
            if flag {
                Client.sharedInstance().attemptToEndSession({ (success, error) in
                    if success {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        Client.showAlert(hostController: self, title: "Logout Failed", message: "There was an error while logging out.")
                    }
                })
            }
        }
    }
    
    @IBAction func pinButtonPressed(sender: AnyObject) {
    }
    
    @IBAction func refreshButtonPressed(sender: AnyObject) {
        Client.sharedInstance().getStudentLocations { (success, error) in
        }
    }
}
