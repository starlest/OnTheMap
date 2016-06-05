//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Edwin Chia on 2/6/16.
//  Copyright © 2016 Edwin Chia. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate {

    // MARK: Properties
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var udacityButtonLoginButton: UIButton!
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    @IBOutlet weak var signupButton: UIButton!    
    
    var activityView: UIActivityIndicatorView!

    // MARK: Life Cycle 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        setUpActivityView()
        setUpFacebookLoginButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        suscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsuscribeToKeyboardNotifications()
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        activityView.center = view.center
    }
    
    // MARK: Protocols
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        /* Make sure to proceed only if an access token is successfully retrieved */
        if Client.sharedInstance().isLoggedInThroughFacebook() {
            startAuthentication(throughFacebook: true)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // MARK: Actions

    @IBAction func udacityLoginButtonPressed(sender: AnyObject) {
        if !areLoginFieldsFilled() {
            Client.showAlert(hostController: self, title: "Missing Field(s)", message: "Please enter both your username and password.")
            return
        }
        if !Reachability.isConnectedToNetwork() {
            Client.showAlert(hostController: self, title: "No Connection", message: "The Internet appears to be offline.")
            return
        }
        startAuthentication(throughFacebook: false)
    }
    
    @IBAction func signupButtonPressed(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: Client.UdacityConstants.SignupURL)!)
    }
}

