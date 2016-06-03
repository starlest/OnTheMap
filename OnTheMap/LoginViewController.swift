//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Edwin Chia on 2/6/16.
//  Copyright © 2016 Edwin Chia. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var udacityButtonLoginButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!    
    
    var activityView: UIActivityIndicatorView!

    // MARK: Life Cycle 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityView.center = view.center
        view.addSubview(activityView)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: Actions

    @IBAction func udacityLoginButtonPressed(sender: AnyObject) {
        if !areLoginFieldsFilled() {
            showAlert("Missing Field(s)", message: "Please enter both your username and password.")
            return
        }
        
        if !Reachability.isConnectedToNetwork() {
            showAlert("No Connection", message: "The Internet appears to be offline")
            return
        }

        setUIEnabled(false)
        
        Client.sharedInstance().authenticateWithViewController(self) { (success, error) in
            performUIUpdatesOnMain({
                if success {
                    self.completeLogin()
                } else {
                    if error?.code == Client.ErrorCodes.InvalidLoginCredentials {
                        self.showAlert("Login Failed", message: "Wrong username or password.")
                    } else if error?.code == Client.ErrorCodes.FailedConnectionToServer {
                        self.showAlert("Connection Failed", message: "Failed to connect to server.")
                    } else {
                        self.showAlert("Unknown Error", message: "Unkown error encountered. Please try again later.")
                    }
                }
                self.setUIEnabled(true)
            })
        }
    }
    
    @IBAction func facebookLoginButtonPressed(sender: AnyObject) {
    }
    
    @IBAction func signupButtonPressed(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: Client.UdacityConstants.SignupURL)!)
    }
}

