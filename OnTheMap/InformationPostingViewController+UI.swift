//
//  InformationPostingViewController+UI.swift
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
        locationTextField.enabled = enabled
        findOnTheMapButton.enabled = enabled
        if !enabled {
            activityView.startAnimating()
        } else {
            activityView.stopAnimating()
        }
    }
    
    func swapUI() {
        cancelButton.tintColor = UIColor.whiteColor()
        
        firstLabel.hidden = true
        secondLabel.hidden = true
        thirdLabel.hidden = true
        locationTextField.hidden = true
        findOnTheMapButton.hidden = true
        
        topContainer.backgroundColor = UIColor.blueColor()
        bottomContainer.backgroundColor = UIColor.blueColor()
        
        urlTextField.hidden = false
        mapView.hidden = false
        submitButton.hidden = false
        
        unsuscribeToKeyboardNotifications()
    }
}