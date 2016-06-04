//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Edwin Chia on 4/6/16.
//  Copyright © 2016 Edwin Chia. All rights reserved.
//

import MapKit

class StudentLocation: NSObject, MKAnnotation {
    
    let objectId: String
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let coordinate: CLLocationCoordinate2D
    
    init(objectId: String, uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double) {
        self.objectId = objectId
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        super.init()
    }
    
    var title: String? {
        return firstName + " " + lastName
    }
    
    var subtitle: String? {
        return mediaURL
    }
}