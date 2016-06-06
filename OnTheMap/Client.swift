//
//  Client.swift
//  OnTheMap
//
//  Created by Edwin Chia on 2/6/16.
//  Copyright © 2016 Edwin Chia. All rights reserved.
//

import Foundation

class Client : NSObject {
    
    // MARK: Properties
    
    // shared session
    let session = NSURLSession.sharedSession()
    
    // authentication state
    var sessionID: String? = nil
    var userID: String? = nil
    var firstName: String? = nil
    var lastName: String? = nil
    
    // MARK: Shared Instance

    static func sharedInstance() -> Client {
        struct Singleton {
            static let sharedInstance = Client()
        }
        return Singleton.sharedInstance
    }

    // MARK: GET
    func taskForGetMethod(request request: NSMutableURLRequest, usingUdacityApi: Bool, completionHandlerForGet: (results: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(errorString: String, errorCode: Int = 1) {
                let userInfo = [NSLocalizedDescriptionKey : errorString]
                completionHandlerForGet(results: nil, error: NSError(domain: "taskForGetMethod", code: errorCode, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2xx response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                var errorCode = ((response as? NSHTTPURLResponse)?.statusCode)!
                
                /* Group 5xx response as server side error under error code 5 */
                if (errorCode >= 500 && errorCode <= 599) {
                    errorCode = errorCode / 100
                }
                
                sendError("Your request returned a status code other than 2xx! \(errorCode)", errorCode: errorCode)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            let results = usingUdacityApi ? data.subdataWithRange(NSMakeRange(5, data.length - 5)) : data
            /* Parse the data and use the data (in the completionHandlerForPost) */
            self.convertDataWithCompletionHandler(results, completionHandlerForConvertData: completionHandlerForGet)
        }

        return task
    }
    
    // MARK: POST
    func taskForPostMethod(request request: NSMutableURLRequest, usingUdacityApi: Bool, completionHandlerForPOST: (results: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(errorString: String, errorCode: Int = 1) {
                print(errorString)
                let userInfo = [NSLocalizedDescriptionKey : errorString]
                completionHandlerForPOST(results: nil, error: NSError(domain: "taskForPostMethod", code: errorCode, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2xx response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                var errorCode = ((response as? NSHTTPURLResponse)?.statusCode)!
                
                /* Group 5xx response as server side error under error code 5 */
                if (errorCode >= 500 && errorCode <= 599) {
                    errorCode = errorCode / 100
                }
                
                sendError("Your request returned a status code other than 2xx! \(errorCode)", errorCode: errorCode)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            let results = usingUdacityApi ? data.subdataWithRange(NSMakeRange(5, data.length - 5)) : data
            /* Parse the data and use the data (in the completionHandlerForPost) */
            self.convertDataWithCompletionHandler(results, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        return task
    }
}