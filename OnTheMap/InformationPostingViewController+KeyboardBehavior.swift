//
//  InformationPostingViewController+KeyboardBehavior.swift
//  OnTheMap
//
//  Created by Edwin Chia on 6/6/16.
//  Copyright © 2016 Edwin Chia. All rights reserved.
//

extension InformationPostingViewController {
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        // Reset the view's origin before performing calculations below
        view.frame.origin.y = 0.0
        
        /* Only shift the view up if the keyboard covers the textfield */
        let keyboardHeight = getKeyboardHeight(notification)
        let offset: CGFloat = 40.0
        var rectWithKeyboard : CGRect = view.frame
        rectWithKeyboard.size.height -= keyboardHeight
        
        if !CGRectContainsRect(rectWithKeyboard, textField!.frame)
        {
            view.frame.origin.y = keyboardHeight * (-1) + (textField.frame.origin.y - rectWithKeyboard.origin.y - offset)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    func suscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsuscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
}