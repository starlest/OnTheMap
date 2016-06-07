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
                self.placeMark = placemarks![0]
                let annotation = MKPlacemark(placemark: self.placeMark!)
                self.mapView.addAnnotation(annotation)
                self.mapView.showAnnotations([annotation], animated: true)
            })
        }
    }
    
    func attemptToPostLocation() {
        let studentLocation = getStudentLocation()
        Client.sharedInstance().postLocation(studentLocation) { (success, error) in
            performUIUpdatesOnMain({
                if success {
                    Client.showAlert(hostController: self, title: "Post Success", message: "Your location has been successfully posted!", dimissHostController: true)
                } else {
                    Client.showAlert(hostController: self, title: "Post Failure", message: "Failed to post your location.")
                }
            })
        }
    }
    
    func getStudentLocation() -> StudentLocation {
        let uniqueKey = Client.sharedInstance().userID!
        let firstName = Client.sharedInstance().firstName!
        let lastName = Client.sharedInstance().lastName!
        let mapString = locationTextField.text!
        let mediaURL = urlTextField.text!
        let latitude = (placeMark?.location?.coordinate.latitude)! as Double
        let longitude = (placeMark?.location?.coordinate.longitude)! as Double
        
        var dictionary = [String:AnyObject]()
        dictionary[Client.ParseJSONResponseKeys.ObjectId] = nil
        dictionary[Client.ParseJSONResponseKeys.UniqueKey] = uniqueKey
        dictionary[Client.ParseJSONResponseKeys.FirstName] = firstName
        dictionary[Client.ParseJSONResponseKeys.LastName] = lastName
        dictionary[Client.ParseJSONResponseKeys.MapString] = mapString
        dictionary[Client.ParseJSONResponseKeys.MediaURL] = mediaURL
        dictionary[Client.ParseJSONResponseKeys.Latitude] = latitude
        dictionary[Client.ParseJSONResponseKeys.Longitude] = longitude
        
        return StudentLocation(studentLocation: dictionary)!
    }
}