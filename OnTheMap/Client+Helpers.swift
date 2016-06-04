//
//  Client+Helpers.swift
//  OnTheMap
//
//  Created by Edwin Chia on 2/6/16.
//  Copyright © 2016 Edwin Chia. All rights reserved.
//

import Foundation

extension Client {
    
    func createUdacityURLFromParameters(parameters: [String:AnyObject], withPathExtension: String? = nil) -> NSURL {

        let components = NSURLComponents()
        components.scheme = UdacityConstants.ApiScheme
        components.host = UdacityConstants.ApiHost
        components.path = UdacityConstants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.URL!
    }
    
    func setRequestHTTPPOSTSettings(request: NSMutableURLRequest, htmlHeaderFields: [String:String], jsonBody: String) {
        request.HTTPMethod = "POST"
        for (forHTTPHeaderField, value) in htmlHeaderFields {
            request.addValue(value, forHTTPHeaderField: forHTTPHeaderField)
        }
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
    }
    
    func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil)
    }
    
    func isLoggedInThroughFacebook() -> Bool {
        return FBSDKAccessToken.currentAccessToken() != nil
    }
    
    func attemptToLogoutFacebook() {
        if (isLoggedInThroughFacebook()) {
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
        }
    }
    
    static func showAlert(hostController hostController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let alertAction = UIAlertAction(title: "Dimiss", style: .Default, handler: { (UIAlertAction) in
            alert.dismissViewControllerAnimated(true, completion: nil)
        })
        alert.addAction(alertAction)
        hostController.presentViewController(alert, animated: true, completion: nil)
    }
    
    static func showLogoutConfirmationAlert(hostController hostController: UIViewController, confirmationHandler: (flag: Bool) -> Void) {
        let alert = UIAlertController(title: "Confirmation", message: "Confirm logging out?", preferredStyle: .ActionSheet)
        
        let yesAlertAction = UIAlertAction(title: "Yes", style: .Default, handler: { (UIAlertAction) in
            alert.dismissViewControllerAnimated(true, completion: nil)
            confirmationHandler(flag: true)
        })
        
        let noAlertAction = UIAlertAction(title: "No", style: .Default, handler: { (UIAlertAction) in
            alert.dismissViewControllerAnimated(true, completion: nil)
            confirmationHandler(flag: false)
        })
        
        alert.addAction(yesAlertAction)
        alert.addAction(noAlertAction)
        hostController.presentViewController(alert, animated: true, completion: nil)
    }
}
