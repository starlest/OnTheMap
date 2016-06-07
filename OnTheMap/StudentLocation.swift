//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Edwin Chia on 4/6/16.
//  Copyright © 2016 Edwin Chia. All rights reserved.
//

import MapKit

struct StudentLocation {
    
    let objectId: String?
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    
    init?(studentLocation: [String:AnyObject]) {
        
        /*
         * Check if the dictionary provides the required information in the right format; fail the initialiser otherwise
         * and store them using the same keys as the ParseJSONReponseKeys 
         */
        
        if let objectId = studentLocation[Client.ParseJSONResponseKeys.ObjectId] as? String? {
            self.objectId = objectId
        } else {
            return nil
        }
        
        if let uniqueKey = studentLocation[Client.ParseJSONResponseKeys.UniqueKey] as? String {
            self.uniqueKey = uniqueKey
        } else {
            return nil
        }
        
        if let firstName = studentLocation[Client.ParseJSONResponseKeys.FirstName] as? String {
            self.firstName = firstName
        } else {
            return nil
        }
        
        if let lastName = studentLocation[Client.ParseJSONResponseKeys.LastName] as? String {
            self.lastName = lastName
        } else {
            return nil
        }
        
        if let mapString = studentLocation[Client.ParseJSONResponseKeys.MapString] as? String {
            self.mapString = mapString
        } else {
            return nil
        }
        
        if let mediaURL = studentLocation[Client.ParseJSONResponseKeys.MediaURL] as? String {
            self.mediaURL = mediaURL
        } else {
            return nil
        }
        
        if let latitude = studentLocation[Client.ParseJSONResponseKeys.Latitude] as? Double  {
            self.latitude = latitude
        } else {
            return nil
        }
        
        if let longitude = studentLocation[Client.ParseJSONResponseKeys.Longitude] as? Double  {
            self.longitude = longitude
        } else {
            return nil
        }
    }
}