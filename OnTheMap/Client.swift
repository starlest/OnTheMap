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
    var requestToken: String? = nil
    var sessionID: String? = nil
    var userID: Int? = nil

    // MARK: Shared Instance

    static func sharedInstance() -> Client {
        struct Singleton {
            static let sharedInstance = Client()
        }
        return Singleton.sharedInstance
    }

    // MARK: Initializers

    override init() {
        super.init()
    }

    // MARK: GET
    func taskForGetMethod(method: String, parameters: [String:AnyObject], completionHandlerForGet: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let request = NSMutableURLRequest(URL: createUdacityURLFromParameters(parameters, withPathExtension: method))
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            //
        }
        
        return task
    }
    
    // MARK: POST
    func taskForPostMethod(method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: (results: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let request = NSMutableURLRequest(URL: createUdacityURLFromParameters(parameters, withPathExtension: method))
        setRequestHTTPPOSTSettings(request, jsonBody: jsonBody)

        /* Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(errorString: String, errorCode: Int = 1) {
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
                if (errorCode != 403) {
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
            
            let subData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
            /* Parse the data and use the data (in the completionHandlerForPost) */
            self.convertDataWithCompletionHandler(subData, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        task.resume()
        
        return task
    }
    
    private func setRequestHTTPPOSTSettings(request: NSMutableURLRequest, jsonBody: String) {
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
    }
}