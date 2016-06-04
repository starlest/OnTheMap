//
//  TableTabViewController+Helpers.swift
//  OnTheMap
//
//  Created by Edwin Chia on 5/6/16.
//  Copyright © 2016 Edwin Chia. All rights reserved.
//

import Foundation

extension TableTabViewController {
    
    func setUpActivityView() {
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityView.center = view.center
        view.addSubview(activityView)
    }
    
    func downloadUserLocations() {
        
        enableUI(false)
        
        Client.sharedInstance().getStudentLocations { (success, error) in
            if (success) {
                
                performUIUpdatesOnMain({
                    for studentLocaton in self.studentLocations {
                    }
                })
                
            } else {
                Client.showAlert(hostController: self, title: "Download Failed", message: "Failed to download student locations. \n Error Code: \(error!.code)")
            }
            
            performUIUpdatesOnMain({
                self.enableUI(false)
            })
        }
    }
    
    func enableUI(enabled: Bool) {
        logoutButton.enabled = enabled
        pinButton.enabled = enabled
        refreshButton.enabled = enabled
    }
}