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
    
    var studentLocations: [StudentLocation] {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.studentLocations
    }
    
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
                        Client.showAlert(hostController: self, title: "Logout Failed", message: "There was an error while logging out. \n Error Code: \(error!.code)")
                    }
                })
            }
        }
    }
    
    @IBAction func pinButtonPressed(sender: AnyObject) {
    }
    
    @IBAction func refreshButtonPressed(sender: AnyObject) {
        Client.sharedInstance().getStudentLocations { (success, error) in
            if (success) {
                print(self.studentLocations)
            } else {
                Client.showAlert(hostController: self, title: "Load Failed", message: "Failed to load student locations. \n Error Code: \(error!.code)")
            }
        }
    }
}
