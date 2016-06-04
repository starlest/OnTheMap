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
    }
    
    // MARK: Udacity Parameter Values
    struct UdacityParameterValues {
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
    }
    
    // MARK: HTML Header Values
    struct HTMLHeaderValues {
        static let ApplicationJSON = "application/json"
    }
    
    // MARK: Error Codes 
    struct ErrorCodes {
        static let FailedConnectionToServer = 5
        static let InvalidLoginCredentials = 403
    }
}