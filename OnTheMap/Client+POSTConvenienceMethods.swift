//
//  Client+POSTConvenienceMethods.swift
//  OnTheMap
//
//  Created by Edwin Chia on 6/6/16.
//  Copyright © 2016 Edwin Chia. All rights reserved.
//

extension Client {
    
    func authenticateWithViewController(hostViewController: UIViewController, throughFacebook: Bool, completionHandlerForAuth: (success: Bool, error: NSError?) -> Void) {
        
        let controller = hostViewController as! LoginViewController
        let username = controller.emailTextField.text!
        let password = controller.passwordTextField.text!
        
        
        getSessionID(throughFacebook: throughFacebook, username: username, password: password) { (success, sessionID, error) in
            if success {
                self.sessionID = sessionID
                completionHandlerForAuth(success: true, error: error)
            } else {
                completionHandlerForAuth(success: false, error: error)
            }
        }
    }
    
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
        
        let jsonBody = throughFacebook ? "{\"\(UdacityJSONBodyKeys.FacebookMobile)\": {\"\(UdacityJSONBodyKeys.FacebookAcessToken)\": \"\(FBSDKAccessToken.currentAccessToken().tokenString)\"}}" : "{\"\(UdacityJSONBodyKeys.Udacity)\": {\"\(UdacityJSONBodyKeys.Username)\": \"\(username!)\", \"\(UdacityJSONBodyKeys.Password)\": \"\(password!)\"}}"
        
        let request = NSMutableURLRequest(URL: createUdacityURLFromParameters(parameters, withPathExtension: UdacityMethods.Session))
        setRequestHTTPSettings(request, method: "POST", htmlHeaderFields: htmlHeaderFields, withJsonBody: jsonBody)
        
        return request
    }
}
