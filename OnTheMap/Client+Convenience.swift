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
            self.getSessionID(username, password: password) { (success, sessionID, error) in
                if (success) {
                    self.sessionID = sessionID
                    completionHandlerForAuth(success: true, error: error)
                } else {
                    completionHandlerForAuth(success: false, error: error)
                }
            }
        } else {
            self.getSessionIDThroughFacebook() { (success, sessionID, error) in
                if (success) {
                    self.sessionID = sessionID
                    completionHandlerForAuth(success: true, error: error)
                } else {
                    completionHandlerForAuth(success: false, error: error)
                }
            }
        }
    }
    
    // MARK: POST Convenience Methods
    
    private func getSessionID(username: String, password: String, completionHandlerForSession: (success: Bool, sessionID: String?, error: NSError?) -> Void) {

        let parameters = [String:AnyObject]()

        let jsonBody = "{\"\(UdacityJSONBodyKeys.Udacity)\": {\"\(UdacityJSONBodyKeys.Username)\": \"\(username)\", \"\(UdacityJSONBodyKeys.Password)\": \"\(password)\"}}"
        
        taskForPostMethod(UdacityMethods.Session, parameters: parameters, jsonBody: jsonBody) { (results, error) in
            
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

        taskForPostMethod(UdacityMethods.Session, parameters: parameters, jsonBody: jsonBody) { (results, error) in
            
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
}