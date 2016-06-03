//
//  LoginViewController+UIConfigurations.swift
//  OnTheMap
//
//  Created by Edwin Chia on 2/6/16.
//  Copyright © 2016 Edwin Chia. All rights reserved.
//

extension LoginViewController {
    
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
    
    func completeLogin() {
        
    }
}
