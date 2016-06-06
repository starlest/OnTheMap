//
//  Client+DELETEConvenienceMethods.swift
//  OnTheMap
//
//  Created by Edwin Chia on 6/6/16.
//  Copyright © 2016 Edwin Chia. All rights reserved.
//

extension Client {
    
    func attemptToLogOutWithController(hostController: UIViewController, completionHandler: (success: Bool, error: NSError?) -> Void) {
        let alert = UIAlertController(title: nil, message: "Confirm logging out?", preferredStyle: .ActionSheet)
        
        let yesAlertAction = UIAlertAction(title: "Yes", style: .Default, handler: { (UIAlertAction) in
            alert.dismissViewControllerAnimated(true, completion: nil)
            Client.sharedInstance().attemptToEndSession({ (success, error) in
                if success {
                    completionHandler(success: true, error: nil)
                } else {
                    completionHandler(success: false, error: error)
                }
            })
        })
        
        let noAlertAction = UIAlertAction(title: "No", style: .Default, handler: { (UIAlertAction) in
            alert.dismissViewControllerAnimated(true, completion: nil)
            completionHandler(success: false, error: nil)
        })
        
        alert.addAction(yesAlertAction)
        alert.addAction(noAlertAction)
        hostController.presentViewController(alert, animated: true, completion: nil)
    }
    
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