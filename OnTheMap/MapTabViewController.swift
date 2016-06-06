//
//  MapTabViewController.swift
//  OnTheMap
//
//  Created by Edwin Chia on 3/6/16.
//  Copyright © 2016 Edwin Chia. All rights reserved.
//

import UIKit
import MapKit

class MapTabViewController: TabViewController, MKMapViewDelegate {

    // MARK: Properties
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var pinButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    var studentLocations: [StudentLocation] {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.studentLocations
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpActivityView()
        mapView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        downloadUserLocations()
    }
    
    // MARK: Protocols
    
    override func enableUI(enabled: Bool) {
        logoutButton.enabled = enabled
        pinButton.enabled = enabled
        refreshButton.enabled = enabled
        mapView.alpha = enabled ? 1.0 : 0.5
        if enabled {
            self.activityView.stopAnimating()
        } else {
            self.activityView.startAnimating()
        }
    }
    
    override func reloadDataDisplayed() {
        mapView.removeAnnotations(mapView.annotations)
        for studentLocaton in self.studentLocations {
            mapView.addAnnotation(studentLocaton)
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotation = annotation as? StudentLocation {
            
            let identifier = "pin"
            var view: MKPinAnnotationView
            
            if let dequedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequedView.annotation = annotation
                view = dequedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: -5)
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            }
            
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        /* Opens the user's specified URL in Safari when detail disclosure info button is pressed */
        let studentLocation = view.annotation as! StudentLocation
        UIApplication.sharedApplication().openURL(NSURL(string: studentLocation.mediaURL)!)
    }
    
    // MARK: Actions
    
    @IBAction func logoutButtonPressed(sender: AnyObject) {
        logout()
    }
    
    @IBAction func pinButtonPressed(sender: AnyObject) {
        let controller = storyboard?.instantiateViewControllerWithIdentifier("InformationPostingViewController") as! InformationPostingViewController
        presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func refreshButtonPressed(sender: AnyObject) {
        downloadUserLocations()
    }
}
