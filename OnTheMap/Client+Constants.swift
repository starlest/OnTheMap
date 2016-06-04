//
//  Client+Constants.swift
//  OnTheMap
//
//  Created by Edwin Chia on 2/6/16.
//  Copyright © 2016 Edwin Chia. All rights reserved.
//

extension Client {
    
    // MARK: Parse Constants
    struct ParseConstants {
        static let ApiKey = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RESTApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"

        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "api.parse.com"
        static let ApiPath = "/1/classes"
    }
    
    // MARK: Parse Parameter Keys
    struct ParseParameterKeys {
        static let Limit = "limit"
        static let Skip = "skip"
        static let Order = "order"
    }
    
    // MARK: Parse Parameter Values
    struct ParseParameterValues {
    }
    
    // MARK: Parse Methods
    struct ParseMethods {
        static let StudentLocation = "/StudentLocation"
    }
    
    // MARK: Udacity Response Keys
    struct ParseJSONResponseKeys {
        static let Results = "results"
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
    }
    
    // MARK: Udacity Constants
    struct UdacityConstants {
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
        static let SignupURL = "https://www.udacity.com/account/auth#!/signup"
        
    }

    // MARK: Udacity Methods
    struct UdacityMethods {
        static let Session = "/session"
    }
    
    // MARK: Udacity Body Keys
    struct UdacityJSONBodyKeys {
        // MARK: Authorization
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
        static let FacebookMobile = "facebook_mobile"
        static let FacebookAcessToken = "acesss_token"
    }
    
    // MARK: Udacity Response Keys
    struct UdacityJSONResponseKeys {
        // MARK: Authorization
        static let Session = "session"
        static let SessionID = "id"
    }
    
    // MARK: HTML Header Fields
    struct HTMLHeaderFields {
        static let Accept = "Accept"
        static let ContentType = "Content-Type"
        static let XParseApplicationId = "X-Parse-Application-Id"
        static let XParseRESTApiKey = "X-Parse-REST-API-Key"
    }
    
    // MARK: HTML Header Values
    struct HTMLHeaderValues {
        static let ApplicationJSON = "application/json"
    }
    
    // MARK: Error Codes 
    struct ErrorCodes {
        static let FailedToParseData = 0
        static let FailedConnectionToServer = 5
        static let InvalidLoginCredentials = 403
    }
}