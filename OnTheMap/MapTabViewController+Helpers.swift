//
//  MapTabViewController+Helpers.swift
//  OnTheMap
//
//  Created by Edwin Chia on 5/6/16.
//  Copyright © 2016 Edwin Chia. All rights reserved.
//

extension MapTabViewController {
 
    func setUpActivityView() {
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityView.center = view.center
        view.addSubview(activityView)
    }
    
    func downloadUserLocations() {
        self.enableUI(false)
        
        Client.sharedInstance().getStudentLocations { (success, error) in
            
            if (success) {
                performUIUpdatesOnMain({
                    for studentLocaton in self.studentLocations {
                        self.mapView.addAnnotation(studentLocaton)
                    }
                })                
            } else {
                performUIUpdatesOnMain({
                    Client.showAlert(hostController: self, title: "Download Failed", message: "Failed to download student locations. \n Error Code: \(error!.code)")
                })
            }
            
            performUIUpdatesOnMain({
                self.enableUI(true)
            })
        }
    }
    
    func logout() {
        enableUI(false)
        
        Client.attemptToLogOut(hostController: self) { (success, error) in
            
            if success {
                performUIUpdatesOnMain({
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            } else {
                performUIUpdatesOnMain({
                    if let error = error {
                        Client.showAlert(hostController: self, title: "Logout Failed", message: "There was an error while logging out. \n Error Code: \(error.code)")
                    }
                    self.enableUI(true)
                })
            }
        }
    }
    
    func enableUI(enabled: Bool) {
        logoutButton.enabled = enabled
        pinButton.enabled = enabled
        refreshButton.enabled = enabled
        mapView.alpha = enabled ? 1.0 : 0.5
        if enabled {
            self.activityView.stopAnimating()
        } else {
            self.activityView.startAnimating()
        }
    }
}