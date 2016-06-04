//
//  LoginViewController+Helpers.swift
//  OnTheMap
//
//  Created by Edwin Chia on 3/6/16.
//  Copyright © 2016 Edwin Chia. All rights reserved.
//

import Foundation

extension LoginViewController {
    
    func setUpActivityView() {
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityView.center = view.center
        view.addSubview(activityView)
    }
    
    func setUpFacebookLoginButton() {
        facebookLoginButton.delegate = self
        facebookLoginButton.readPermissions = ["email"]
    }
    
    func areLoginFieldsFilled() -> Bool {
        if emailTextField.text == nil || passwordTextField.text == nil {
            return false
        }
        return emailTextField.text?.characters.count > 0 && passwordTextField.text?.characters.count > 0
    }
    
    func setUIEnabled(enabled: Bool) {
        udacityButtonLoginButton.enabled = enabled
        facebookLoginButton.enabled = enabled
        signupButton.enabled = enabled
        emailTextField.enabled = enabled
        passwordTextField.enabled = enabled
        
        if !enabled {
            activityView.startAnimating()
        } else {
            activityView.stopAnimating()
        }
    }
    
    func startAuthentication(throughFacebook throughFacebook: Bool) {
        setUIEnabled(false)
        Client.sharedInstance().authenticateWithViewController(self, throughFacebook: throughFacebook) { (success, error) in
            performUIUpdatesOnMain({
                if success {
                    self.completeLogin()
                } else {
                    if error?.code == Client.ErrorCodes.InvalidLoginCredentials {
                        let message = throughFacebook ? "Your Facebook Account is not linked to an Udacity account. \n Error Code: \(error!.code)" : "Wrong username or password. \n Error Code: \(error!.code)"
                        Client.showAlert(hostController: self, title: "Login Failed", message: message)
                    } else if error?.code == Client.ErrorCodes.FailedConnectionToServer {
                        Client.showAlert(hostController: self, title: "Connection Failed", message: "Failed to connect to server. \n Error Code: \(error!.code)")
                    } else {
                        Client.showAlert(hostController: self, title: "Unknown Error", message: "Unkown error encountered. Please try again later. \n Error Code: \(error!.code)")
                    }
                }
                self.setUIEnabled(true)
            })
        }
    }
    
    func completeLogin() {
        let controller = storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
        presentViewController(controller, animated: true, completion: nil)
    }
}