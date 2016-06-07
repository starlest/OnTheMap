//
//  Client+POSTConvenienceMethods.swift
//  OnTheMap
//
//  Created by Edwin Chia on 6/6/16.
//  Copyright © 2016 Edwin Chia. All rights reserved.
//

import CoreLocation

extension Client {
    
    // MARK: Authentication Methods
    
    func authenticateWithViewController(hostViewController: UIViewController, throughFacebook: Bool, completionHandlerForAuth: (success: Bool, error: NSError?) -> Void) {
        
        let controller = hostViewController as! LoginViewController
        let username = controller.emailTextField.text!
        let password = controller.passwordTextField.text!
        
        
        attemptToEstablishSession(throughFacebook: throughFacebook, username: username, password: password) { (success, error) in
            if success {
                completionHandlerForAuth(success: true, error: error)
            } else {
                completionHandlerForAuth(success: false, error: error)
            }
        }
    }
    
    private func attemptToEstablishSession(throughFacebook throughFacebook: Bool, username: String? = nil, password: String? = nil, completionHandlerForSession: (success: Bool, error: NSError?) -> Void) {
        
        let request = createGetSessionIdRequest(throughFacebook: throughFacebook, username: username, password: password)
        
        let task = taskForPostMethod(request: request, usingUdacityApi: true) { (results, error) in
            
            if let error = error {
                completionHandlerForSession(success: false, error: error)
                return
            }
            
            if let session = results[UdacityJSONResponseKeys.Session] as? NSDictionary, sessionID = session[UdacityJSONResponseKeys.SessionID] as? String, account = results[UdacityJSONResponseKeys.Account] as? NSDictionary, userID = account[UdacityJSONResponseKeys.Key] as? String {
                self.userID = userID
                self.sessionID = sessionID
                self.getName({ (success, error) in
                    if success {
                        completionHandlerForSession(success: true, error: nil)
                    } else {
                        let customError = NSError(domain: "getName", code: 2, userInfo: [NSLocalizedDescriptionKey : "Failed to retrieve user's data."])
                        completionHandlerForSession(success: false, error: customError)
                        self.userID = nil
                        self.sessionID = nil
                        return
                    }
                })
            } else {
                completionHandlerForSession(success: false, error: NSError(domain: "getSessionID parsing", code: ErrorCodes.FailedToParseData, userInfo: [NSLocalizedDescriptionKey: "Could not parse getSessionID"]))
            }
        }
        
        task.resume()
    }
    
    private func createGetSessionIdRequest(throughFacebook throughFacebook: Bool, username: String? = nil, password: String? = nil) -> NSMutableURLRequest {
        
        let parameters = [String:AnyObject]()
        
        let htmlHeaderFields = [
            HTMLHeaderFields.Accept : HTMLHeaderValues.ApplicationJSON,
            HTMLHeaderFields.ContentType : HTMLHeaderValues.ApplicationJSON
        ]
        
        let jsonBody = throughFacebook ? "{\"\(UdacityJSONBodyKeys.FacebookMobile)\": {\"\(UdacityJSONBodyKeys.FacebookAcessToken)\": \"\(FBSDKAccessToken.currentAccessToken().tokenString)\"}}" : "{\"\(UdacityJSONBodyKeys.Udacity)\": {\"\(UdacityJSONBodyKeys.Username)\": \"\(username!)\", \"\(UdacityJSONBodyKeys.Password)\": \"\(password!)\"}}"
        
        let request = NSMutableURLRequest(URL: createUdacityURLFromParameters(parameters, withPathExtension: UdacityMethods.Session))
        setRequestHTTPSettings(request, method: "POST", htmlHeaderFields: htmlHeaderFields, withJsonBody: jsonBody)
        
        return request
    }
    
    // MARK: Posting Location Methods
    
    func postLocation(studentLocation: StudentLocation, completionHandlerForPost: (success: Bool, error: NSError?) -> Void) {
        
        let request = createPostLocationRequest(studentLocation)
        
        let task = taskForPostMethod(request: request, usingUdacityApi: false) { (results, error) in
            
            guard error == nil else {
                completionHandlerForPost(success: false, error: error)
                return
            }

            completionHandlerForPost(success: true, error: nil)
        }
        
        task.resume()
    }
    
    private func createPostLocationRequest(studentLocation: StudentLocation) -> NSMutableURLRequest {
        
        let parameters = [String:AnyObject]()
        
        let htmlHeaderFields = [
            HTMLHeaderFields.XParseApplicationId : ParseConstants.ApiKey,
            HTMLHeaderFields.XParseRESTApiKey : ParseConstants.RESTApiKey,
            HTMLHeaderFields.ContentType : HTMLHeaderValues.ApplicationJSON
        ]
        
        let jsonBody = "{\"\(ParseJSONResponseKeys.UniqueKey)\": \"\(studentLocation.uniqueKey)\", \"\(ParseJSONResponseKeys.FirstName)\": \"\(studentLocation.firstName)\", \"\(ParseJSONResponseKeys.LastName)\": \"\(studentLocation.lastName)\",\"\(ParseJSONResponseKeys.MapString)\": \"\(studentLocation.mapString)\", \"\(ParseJSONResponseKeys.MediaURL)\": \"\(studentLocation.mediaURL)\",\"\(ParseJSONResponseKeys.Latitude)\": \(studentLocation.latitude), \"\(ParseJSONResponseKeys.Longitude)\": \(studentLocation.longitude)}"
        
        let request = NSMutableURLRequest(URL: createParseURLFromParameters(parameters, withPathExtension: ParseMethods.StudentLocation))
        setRequestHTTPSettings(request, method: "POST", htmlHeaderFields: htmlHeaderFields, withJsonBody: jsonBody)
        
        return request
    }
}
