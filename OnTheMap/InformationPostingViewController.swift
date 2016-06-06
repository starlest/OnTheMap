//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Edwin Chia on 5/6/16.
//  Copyright © 2016 Edwin Chia. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {

    /* MARK: Properties */
    @IBOutlet weak var topContainer: UIView!
    @IBOutlet weak var bottomContainer: UIView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var findOnTheMapButton: UIButton!
    
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    
    var activityView: UIActivityIndicatorView!
    
    var placeMark: CLPlacemark?

    /* MARK: Lifecycle */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpActivityView()
        mapView.delegate = self
        locationTextField.delegate = self
        urlTextField.delegate = self
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
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
        if !hasUserEnteredAURL() {
            Client.showAlert(hostController: self, title: "Invalid URL", message: "Please enter a URL.")
            return
        }
        attemptToPostLocation()
    }
}
