//
//  Client+GETConvenienceMethods.swift
//  OnTheMap
//
//  Created by Edwin Chia on 2/6/16.
//  Copyright © 2016 Edwin Chia. All rights reserved.
//

extension Client {
    
    func getStudentLocations(completionHandlerForGet: (success: Bool, error: NSError?) -> Void) {

        let parameters = [
            ParseParameterKeys.Limit : "100"
        ]
        
        let htmlHeaderFields = [
            HTMLHeaderFields.XParseApplicationId : ParseConstants.ApiKey,
            HTMLHeaderFields.XParseRESTApiKey : ParseConstants.RESTApiKey
        ]
        
        let request = NSMutableURLRequest(URL: createParseURLFromParameters(parameters, withPathExtension: ParseMethods.StudentLocation))
        setRequestHTTPSettings(request, method: "GET", htmlHeaderFields: htmlHeaderFields)

        let task = taskForGetMethod(request: request, usingUdacityApi: false) { (results, error) in
            
            /* GUARD: Was there an error? */
            guard error == nil else {
                completionHandlerForGet(success: false, error: error)
                return
            }
            
            if let studentLocations = results[ParseJSONResponseKeys.Results] as? [[String:AnyObject]] {
                self.storeStudentLocations(studentLocations)
                completionHandlerForGet(success: true, error: nil)
            } else {
                completionHandlerForGet(success: false, error: NSError(domain: "getStudentLocations parsing", code: ErrorCodes.FailedToParseData, userInfo: [NSLocalizedDescriptionKey: "Could not parse studentLocations"]))
            }
        }
        
        task.resume()
    }
    
    func getName(completionHandlerForGet: (success: Bool, error: NSError?) -> Void) {
        
        let parameters = [String:AnyObject]()
        let htmlHeaderFields = [String:String]()
        let pathExtension = UdacityMethods.Users + "/\(userID!)"
        let request =  NSMutableURLRequest(URL: createUdacityURLFromParameters(parameters, withPathExtension: pathExtension))
        setRequestHTTPSettings(request, method: "GET", htmlHeaderFields: htmlHeaderFields)
  
        let task = taskForGetMethod(request: request, usingUdacityApi: true) { (results, error) in
            
            /* GUARD: Was there an error? */
            guard error == nil else {
                completionHandlerForGet(success: false, error: error)
                return
            }
            
            if let user = results[UdacityJSONResponseKeys.User] as? NSDictionary, firstName = user[UdacityJSONResponseKeys.FirstName] as? String,
                lastName = user[UdacityJSONResponseKeys.LastName] as? String
            {
                self.firstName = firstName
                self.lastName = lastName
                completionHandlerForGet(success: true, error: nil)
            } else {
                completionHandlerForGet(success: false, error: NSError(domain: "getName parsing", code: ErrorCodes.FailedToParseData, userInfo: [NSLocalizedDescriptionKey: "Could not parse user's data"]))
            }
        }
        
        task.resume()
    }
}