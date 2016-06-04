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
        setMapViewUI(isLoading: true)
        
        Client.sharedInstance().getStudentLocations { (success, error) in
            if (success) {
                
                performUIUpdatesOnMain({
                    for studentLocaton in self.studentLocations {
                        self.mapView.addAnnotation(studentLocaton)
                    }
                })
                
            } else {
                Client.showAlert(hostController: self, title: "Download Failed", message: "Failed to download student locations. \n Error Code: \(error!.code)")
            }
            
            performUIUpdatesOnMain({
                self.setMapViewUI(isLoading: false)
            })
        }
    }
    
    private func setMapViewUI(isLoading isLoading: Bool) {
        refreshButton.enabled = !isLoading
        mapView.alpha = isLoading ? 0.5 : 1.0
        if isLoading {
            self.activityView.startAnimating()
        } else {
            self.activityView.stopAnimating()
        }
    }
}