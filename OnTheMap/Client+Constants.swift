//
//  Client+Constants.swift
//  OnTheMap
//
//  Created by Edwin Chia on 2/6/16.
//  Copyright © 2016 Edwin Chia. All rights reserved.
//

extension Client {
    
    // MARK: Facebook Constants
    struct FacebookConstants {
        static let ApiKey = "365362206864879"
    }
    
    // MARK: Udacity Constants
    struct UdacityConstants {
        static let SignupURL = "https://www.udacity.com/account/auth#!/signup"
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
    }

    // MARK: Udacity Methods
    struct UdacityMethods {
        static let Session = "/session"
    }

    // MARK: Udacity Parameter Keys
    struct UdacityParameterKeys {
        static let Username = "username"
        static let Password = "Password"
    }
    
    // MARK: Udacity Parameter Values
    struct UdacityParameterValues {
    }
    
    // MARK: Udacity Reponse Keys
    struct UdacityJSONResponseKeys {
        
        // MARK: Authorization
        static let Session = "session"
    }
    
    // MARK: Error Codes 
    struct ErrorCodes {
        static let FailedConnectionToServer = 5
        static let InvalidLoginCredentials = 403
    }
}