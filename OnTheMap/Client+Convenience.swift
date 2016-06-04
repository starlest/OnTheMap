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
    
    static func authenticateWithViewController(hostViewController: UIViewController, throughFacebook: Bool, completionHandlerForAuth: (success: Bool, error: NSError?) -> Void) {
        
        let controller = hostViewController as! LoginViewController
        let username = controller.emailTextField.text!
        let password = controller.passwordTextField.text!
        
        if !throughFacebook {
            getSessionID(username, password: password) { (success, sessionID, error) in
                if success {
                    self.sessionID = sessionID
                    completionHandlerForAuth(success: true, error: error)
                } else {
                    completionHandlerForAuth(success: false, error: error)
                }
            }
        } else {
            getSessionIDThroughFacebook() { (success, sessionID, error) in
                if success {
                    self.sessionID = sessionID
                    completionHandlerForAuth(success: true, error: error)
                } else {
                    completionHandlerForAuth(success: false, error: error)
                }
            }
        }
    }
    
    func logoutWithViewController(hostViewController: UIViewController, completionHandlerForLogout: (success: Bool, error: NSError?) -> Void) {
        attemptToEndSession { (success, error) in
            if success {
                completionHandlerForLogout(success: true, error: error)
            } else {
                completionHandlerForLogout(success: false, error: error)
            }
        }
    }
    
    // MARK: POST Convenience Methods
    
    private func getSessionID(username: String, password: String, completionHandlerForSession: (success: Bool, sessionID: String?, error: NSError?) -> Void) {

        let parameters = [String:AnyObject]()
        
        let htmlHeaderFields = [
            HTMLHeaderFields.Accept : HTMLHeaderValues.ApplicationJSON,
            HTMLHeaderFields.ContentType : HTMLHeaderValues.ApplicationJSON
         ]
        
        let jsonBody = "{\"\(UdacityJSONBodyKeys.Udacity)\": {\"\(UdacityJSONBodyKeys.Username)\": \"\(username)\", \"\(UdacityJSONBodyKeys.Password)\": \"\(password)\"}}"
        
        taskForPostMethod(UdacityMethods.Session, parameters: parameters, htmlHeaderFields: htmlHeaderFields, jsonBody: jsonBody) { (results, error) in
            
            if let error = error {
                completionHandlerForSession(success: false, sessionID: nil, error: error)
                return
            }
            
            if let session = results[UdacityJSONResponseKeys.Session] as? NSDictionary, sessionID = session[UdacityJSONResponseKeys.SessionID] as? String {
                completionHandlerForSession(success: true, sessionID: sessionID, error: nil)
            } else {
                completionHandlerForSession(success: false, sessionID: nil, error: NSError(domain: "getSessionID parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getSessionID"]))
            }
        }
    }
    
    private func getSessionIDThroughFacebook(completionHandlerForSession: (success: Bool, sessionID: String?, error: NSError?) -> Void) {

        let parameters = [String:AnyObject]()
        
        let jsonBody = "{\"\(UdacityJSONBodyKeys.FacebookMobile)\": {\"\(UdacityJSONBodyKeys.FacebookAcessToken)\": \"\(FBSDKAccessToken.currentAccessToken().tokenString);\"}}"
        
        let htmlHeaderFields = [
            HTMLHeaderFields.Accept : HTMLHeaderValues.ApplicationJSON,
            HTMLHeaderFields.ContentType : HTMLHeaderValues.ApplicationJSON
        ]
        
        taskForPostMethod(UdacityMethods.Session, parameters: parameters, htmlHeaderFields: htmlHeaderFields, jsonBody: jsonBody) { (results, error) in
            
            if let error = error {
                completionHandlerForSession(success: false, sessionID: nil, error: error)
                return
            }
            
            if let session = results[UdacityJSONResponseKeys.Session] as? NSDictionary, sessionID = session[UdacityJSONResponseKeys.SessionID] as? String {
                completionHandlerForSession(success: true, sessionID: sessionID, error: nil)
            } else {
                completionHandlerForSession(success: false, sessionID: nil, error: NSError(domain: "getSessionIDThroughFacebook parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getSessionID"]))
            }
        }
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