//
//  InformationPostingViewController+Helpers.swift
//  OnTheMap
//
//  Created by Edwin Chia on 6/6/16.
//  Copyright © 2016 Edwin Chia. All rights reserved.
//

import MapKit

extension InformationPostingViewController {
    
    func setUpActivityView() {
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityView.center = view.center
        view.addSubview(activityView)
    }
    
    func setUIEnabled(enabled: Bool) {
        cancelButton.enabled = enabled
        locationTextField.enabled = enabled
        findOnTheMapButton.enabled = enabled
        if !enabled {
            activityView.startAnimating()
        } else {
            activityView.stopAnimating()
        }
    }
    
    func hasUserEnteredALocation() -> Bool {
        return locationTextField.text != "" && locationTextField.text != "Enter Your Location Here"
    }
    
    func findLocationOnMap() {
        setUIEnabled(false)
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationTextField.text!) { (placemarks, error) in
            
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
                self.swapUI()
                let annotation = MKPlacemark(placemark: placemarks![0])
                self.mapView.addAnnotation(annotation)
                self.mapView.showAnnotations([annotation], animated: true)
            })
        }
    }
    
    private func swapUI() {
        cancelButton.tintColor = UIColor.whiteColor()
        
        firstLabel.hidden = true
        secondLabel.hidden = true
        thirdLabel.hidden = true
        locationTextField.hidden = true
        findOnTheMapButton.hidden = true
        
        topContainer.backgroundColor = UIColor.blueColor()
        bottomContainer.backgroundColor = UIColor.blueColor()
        
        urlTextField.hidden = false
        mapView.hidden = false
        submitButton.hidden = false
        
        unsuscribeToKeyboardNotifications()
    }
}