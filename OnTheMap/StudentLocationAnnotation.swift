//
//  StudentLocationAnnotation.swift
//  OnTheMap
//
//  Created by Edwin Chia on 7/6/16.
//  Copyright © 2016 Edwin Chia. All rights reserved.
//

import MapKit

class StudentLocationAnnotation: NSObject, MKAnnotation {
    
    var title: String?
    var subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, subtitle: String, latitude: Double, longitude: Double) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        super.init()
    }
}