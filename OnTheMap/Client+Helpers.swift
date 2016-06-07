//
//  Client+Helpers.swift
//  OnTheMap
//
//  Created by Edwin Chia on 2/6/16.
//  Copyright © 2016 Edwin Chia. All rights reserved.
//

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
    
    func createParseURLFromParameters(parameters: [String:AnyObject], withPathExtension: String? = nil) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = ParseConstants.ApiScheme
        components.host = ParseConstants.ApiHost
        components.path = ParseConstants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.URL!
    }
    
    func setRequestHTTPSettings(request: NSMutableURLRequest, method: String, htmlHeaderFields: [String:String], withJsonBody: String? = nil) {
        
        request.HTTPMethod = method
        
        for (forHTTPHeaderField, value) in htmlHeaderFields {
            request.addValue(value, forHTTPHeaderField: forHTTPHeaderField)
        }
        
        if let jsonBody = withJsonBody {
            request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        }
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
    
    func storeStudentLocations(studentLocations: [[String:AnyObject]]) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.studentLocations.removeAll()
        
        for studentLocation in studentLocations {
            let studentLocation = StudentLocation(studentLocation: studentLocation)
            appDelegate.studentLocations.append(studentLocation!)
        }
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
    
    static func attemptToOpenURL(hostController hostController: UIViewController, url: NSURL) {
        if !UIApplication.sharedApplication().openURL(url) {
            showAlert(hostController: hostController, title: "Invalid URL", message: "Failed to open URL.")
        }
    }
        
    static func showAlert(hostController hostController: UIViewController, title: String, message: String, dimissHostController: Bool = false) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let alertAction = UIAlertAction(title: "Dimiss", style: .Default, handler: { (UIAlertAction) in
            if dimissHostController {
                hostController.dismissViewControllerAnimated(true, completion: nil)
            } else {
                alert.dismissViewControllerAnimated(true, completion: nil)
            }
        })
        alert.addAction(alertAction)
        hostController.presentViewController(alert, animated: true, completion: nil)
    }
    
}
