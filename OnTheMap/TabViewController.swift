//
//  TabViewController.swift
//  OnTheMap
//
//  Created by Edwin Chia on 6/6/16.
//  Copyright © 2016 Edwin Chia. All rights reserved.
//

import UIKit

class TabViewController: UIViewController, TabViewControllerProtocol {

    var activityView: UIActivityIndicatorView!
    
    // MARK: Lifecycle 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpActivityView()
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        activityView.center = view.center
    }
    
    // MARK: Protocols
    
    func enableUI(enabled: Bool) {
        fatalError("Must Override func enableUI(enabled: Bool)")
    }
    
    func reloadDataDisplayed() {
        fatalError("Must Override func reloadDataDisplayed()")
    }
    
    // MARK: Methods
    
    func setUpActivityView() {
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityView.center = view.center
        view.addSubview(activityView)
    }
    
    func downloadUserLocations() {
        self.enableUI(false)
        Client.sharedInstance().getStudentLocations { (success, error) in
            performUIUpdatesOnMain({
                if success {
                    self.reloadDataDisplayed()
                } else {
                    Client.showAlert(hostController: self, title: "Download Failed", message: "Failed to download student locations. \n Error Code: \(error!.code)")
                }
                self.enableUI(true)
            })
        }
    }
    
    func logout() {
        enableUI(false)
        Client.sharedInstance().attemptToLogOutWithController(self) { (success, error) in
            performUIUpdatesOnMain({
                if success {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                else {
                    if let error = error {
                        Client.showAlert(hostController: self, title: "Logout Failed", message: "There was an error while logging out. \n Error Code: \(error.code)")
                    }
                    self.enableUI(true)
                }
            })
        }
    }
}
