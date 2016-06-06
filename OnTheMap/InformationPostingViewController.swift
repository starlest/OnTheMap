//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Edwin Chia on 5/6/16.
//  Copyright © 2016 Edwin Chia. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingViewController: UIViewController, UITextFieldDelegate {

    /* MARK: Properties */
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var findOnTheMapButton: UIButton!
    
    var activityView: UIActivityIndicatorView!
    
    /* MARK: Lifecycle */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpActivityView()
        textField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        suscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsuscribeToKeyboardNotifications()
    }
    

    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        activityView.center = view.center
    }
    
    /* MARK: Textfield Protocols */
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /* MARK: Actions */
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
 
    @IBAction func findOnTheMapButtonPressed(sender: AnyObject) {
        if !hasUserEnteredALocation() {
            Client.showAlert(hostController: self, title: "Invalid Location", message: "Please enter a location.")
            return
        } else {
            findLocationOnMap()
        }
    }
    
    func findLocationOnMap() {
        
        setUIEnabled(false)
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(textField.text!) { (placemarks, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                performUIUpdatesOnMain({
                    Client.showAlert(hostController: self, title: "Geocoding Failed", message: "Could not Geocode the String.")
                    self.setUIEnabled(true)
                    
                })
                return
            }
            
            performUIUpdatesOnMain({
                self.setUIEnabled(true)
                let nextController = self.storyboard?.instantiateViewControllerWithIdentifier("InformationPosting2ViewController") as! InformationPosting2ViewController
                self.presentViewController(nextController, animated: true, completion: nil)
            })
        }
    }
}
