//
//  Client+Convenience.swift
//  OnTheMap
//
//  Created by Edwin Chia on 2/6/16.
//  Copyright © 2016 Edwin Chia. All rights reserved.
//

import Foundation
import UIKit

extension Client {
    
    func authenticateWithViewController(hostViewController: UIViewController, throughFacebook: Bool, completionHandlerForAuth: (success: Bool, error: NSError?) -> Void) {
        
        let controller = hostViewController as! LoginViewController
        let username = controller.emailTextField.text!
        let password = controller.passwordTextField.text!
        
        if !throughFacebook {
            getSessionID(throughFacebook: false, username: username, password: password) { (success, sessionID, error) in
                if success {
                    self.sessionID = sessionID
                    completionHandlerForAuth(success: true, error: error)
                } else {
                    completionHandlerForAuth(success: false, error: error)
                }
            }
        } else {
            getSessionID(throughFacebook: true) { (success, sessionID, error) in
                if success {
                    self.sessionID = sessionID
                    completionHandlerForAuth(success: true, error: error)
                } else {
                    completionHandlerForAuth(success: false, error: error)
                }
            }
        }
    }
    
    // MARK: GET Convenience Methods
    
    func getStudentLocations(completionHandlerForSession: (success: Bool, error: NSError?) -> Void) {

        let parameters = [
            ParseParameterKeys.Limit : "100"
        ]
        
        let htmlHeaderFields = [
            HTMLHeaderFields.XParseApplicationId : ParseConstants.ApiKey,
            HTMLHeaderFields.XParseRESTApiKey : ParseConstants.RESTApiKey
        ]
        
        let request = NSMutableURLRequest(URL: createParseURLFromParameters(parameters, withPathExtension: ParseMethods.StudentLocation))
        setRequestHTTPSettings(request, method: "GET", htmlHeaderFields: htmlHeaderFields)

        let task = taskForGetMethod(request: request) { (results, error) in
            
            if let error = error {
                completionHandlerForSession(success: false, error: error)
                return
            }
            
            if let studentLocations = results[ParseJSONResponseKeys.Results] as? [[String:AnyObject]] {
                self.storeStudentLocations(studentLocations)
                completionHandlerForSession(success: true, error: nil)
            } else {
                completionHandlerForSession(success: false, error: NSError(domain: "getStudentLocations parsing", code: ErrorCodes.FailedToParseData, userInfo: [NSLocalizedDescriptionKey: "Could not parse studentLocations"]))
            }
        }
        
        task.resume()
    }

    func storeStudentLocations(studentLocations: [[String:AnyObject]]) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.studentLocations.removeAll()
        
        for studentLocation in studentLocations {
            
            let objectId = studentLocation[ParseJSONResponseKeys.ObjectId] as! String
            let uniqueKey = studentLocation[ParseJSONResponseKeys.UniqueKey] as! String
            let firstName = studentLocation[ParseJSONResponseKeys.FirstName] as! String
            let lastName = studentLocation[ParseJSONResponseKeys.LastName] as! String
            let mapString = studentLocation[ParseJSONResponseKeys.MapString] as! String
            let mediaURL = studentLocation[ParseJSONResponseKeys.MediaURL] as! String
            let latitude = studentLocation[ParseJSONResponseKeys.Latitude] as! Float
            let longtitude = studentLocation[ParseJSONResponseKeys.Longitude] as! Float
            
            let studentLocation = StudentLocation(objectId: objectId, uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longtitude)
            
            appDelegate.studentLocations.append(studentLocation)
        }
    }
    
    // MARK: POST Convenience Methods
    
    private func getSessionID(throughFacebook throughFacebook: Bool, username: String? = nil, password: String? = nil, completionHandlerForSession: (success: Bool, sessionID: String?, error: NSError?) -> Void) {
        
        let request = createGetSessionIdRequest(throughFacebook: throughFacebook, username: username, password: password)
        
        let task = taskForPostMethod(request: request) { (results, error) in
            
            if let error = error {
                completionHandlerForSession(success: false, sessionID: nil, error: error)
                return
            }
            
            if let session = results[UdacityJSONResponseKeys.Session] as? NSDictionary, sessionID = session[UdacityJSONResponseKeys.SessionID] as? String {
                completionHandlerForSession(success: true, sessionID: sessionID, error: nil)
            } else {
                completionHandlerForSession(success: false, sessionID: nil, error: NSError(domain: "getSessionID parsing", code: ErrorCodes.FailedToParseData, userInfo: [NSLocalizedDescriptionKey: "Could not parse getSessionID"]))
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
        
        let jsonBody = throughFacebook ? "{\"\(UdacityJSONBodyKeys.FacebookMobile)\": {\"\(UdacityJSONBodyKeys.FacebookAcessToken)\": \"\(FBSDKAccessToken.currentAccessToken().tokenString);\"}}" : "{\"\(UdacityJSONBodyKeys.Udacity)\": {\"\(UdacityJSONBodyKeys.Username)\": \"\(username!)\", \"\(UdacityJSONBodyKeys.Password)\": \"\(password!)\"}}"
        
        let request = NSMutableURLRequest(URL: createUdacityURLFromParameters(parameters, withPathExtension: UdacityMethods.Session))
        setRequestHTTPSettings(request, method: "POST", htmlHeaderFields: htmlHeaderFields, withJsonBody: jsonBody)

        return request
    }
    
    // MARK: DELETE Convenience Methods
    
    func attemptToEndSession(completionHandlerForEndSession: (success: Bool, error: NSError?) -> Void) {
        
        let request = NSMutableURLRequest(URL: createUdacityURLFromParameters([:], withPathExtension: UdacityMethods.Session))
        request.HTTPMethod = "DELETE"
        
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandlerForEndSession(success: false, error: error)
                return
            } else {
                self.sessionID = nil
                self.attemptToLogoutFacebook()
                completionHandlerForEndSession(success: true, error: error)
            }
        }
        
        task.resume()
    }
}