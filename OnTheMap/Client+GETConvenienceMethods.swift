//
//  Client+GETConvenienceMethods.swift
//  OnTheMap
//
//  Created by Edwin Chia on 2/6/16.
//  Copyright © 2016 Edwin Chia. All rights reserved.
//

extension Client {
    
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
    
   
}