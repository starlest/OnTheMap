//
//  LoginViewController+Helpers.swift
//  OnTheMap
//
//  Created by Edwin Chia on 3/6/16.
//  Copyright © 2016 Edwin Chia. All rights reserved.
//

import Foundation

extension LoginViewController {
    
    private func areLoginFieldsFilled() -> Bool {
        if emailTextField.text == nil || passwordTextField.text == nil {
            return false
        }
        return emailTextField.text?.characters.count > 0 && passwordTextField.text?.characters.count > 0
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let alertAction = UIAlertAction(title: "OK", style: .Default, handler: { (UIAlertAction) in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        alert.addAction(alertAction)
        presentViewController(alert, animated: true, completion: nil)
    }
}