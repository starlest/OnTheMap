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
}