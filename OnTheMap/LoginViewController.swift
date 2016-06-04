//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Edwin Chia on 2/6/16.
//  Copyright © 2016 Edwin Chia. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    // MARK: Properties
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var udacityButtonLoginButton: UIButton!
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    @IBOutlet weak var signupButton: UIButton!    
    
    var activityView: UIActivityIndicatorView!

    // MARK: Life Cycle 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpActivityView()
        setUpFacebookLoginButton()
    }

    
    // MARK: FBSDKLoginButtonDelegate Protocols
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        /* Make sure to proceed only if an access token is successfully retrieved */
        if Client.sharedInstance().isLoggedInThroughFacebook() {
            startAuthentication(throughFacebook: true)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    }

    // MARK: Actions

    @IBAction func udacityLoginButtonPressed(sender: AnyObject) {
        if !areLoginFieldsFilled() {
            Client.showAlert(hostController: self, title: "Missing Field(s)", message: "Please enter both your username and password.")
            return
        }
        if !Reachability.isConnectedToNetwork() {
            Client.showAlert(hostController: self, title: "No Connection", message: "The Internet appears to be offline")
            return
        }
        startAuthentication(throughFacebook: false)
    }
    
    private func startAuthentication(throughFacebook throughFacebook: Bool) {
        setUIEnabled(false)
        Client.authenticateWithViewController(self, throughFacebook: throughFacebook) { (success, error) in
            performUIUpdatesOnMain({
                if success {
                    self.completeLogin()
                } else {
                    if error?.code == Client.ErrorCodes.InvalidLoginCredentials {
                        let message = throughFacebook ? "Your Facebook Account is not linked to an Udacity account." : "Wrong username or password."
                        Client.showAlert(hostController: self, title: "Login Failed", message: message)
                    } else if error?.code == Client.ErrorCodes.FailedConnectionToServer {
                        Client.showAlert(hostController: self, title: "Connection Failed", message: "Failed to connect to server.")
                    } else {
                        Client.showAlert(hostController: self, title: "Unknown Error", message: "Unkown error encountered. Please try again later.")
                    }
                }
                self.setUIEnabled(true)
            })
        }
    }
    
    private func completeLogin() {
        let controller = storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
        presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func signupButtonPressed(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: Client.UdacityConstants.SignupURL)!)
    }
}

