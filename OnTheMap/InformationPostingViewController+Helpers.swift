//
//  InformationPostingViewController+Helpers.swift
//  OnTheMap
//
//  Created by Edwin Chia on 6/6/16.
//  Copyright © 2016 Edwin Chia. All rights reserved.
//

extension InformationPostingViewController {
    
    func setUpActivityView() {
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityView.center = view.center
        view.addSubview(activityView)
    }
    
    func setUIEnabled(enabled: Bool) {
        cancelButton.enabled = enabled
        textField.enabled = enabled
        findOnTheMapButton.enabled = enabled
        if !enabled {
            activityView.startAnimating()
        } else {
            activityView.stopAnimating()
        }
    }
    
    func hasUserEnteredALocation() -> Bool {
        return textField.text != "" && textField.text != "Enter Your Location Here"
    }
}