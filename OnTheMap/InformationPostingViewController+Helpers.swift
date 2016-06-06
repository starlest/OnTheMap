//
//  InformationPostingViewController+Helpers.swift
//  OnTheMap
//
//  Created by Edwin Chia on 6/6/16.
//  Copyright © 2016 Edwin Chia. All rights reserved.
//

import MapKit

extension InformationPostingViewController {
    
    func hasUserEnteredALocation() -> Bool {
        return locationTextField.text != "" && locationTextField.text != "Enter Your Location Here"
    }
    
    func hasUserEnteredAURL() -> Bool {
        return urlTextField.text != "" && urlTextField.text != "Enter a Link to Share"
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
}