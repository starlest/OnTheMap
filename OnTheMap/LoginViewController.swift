//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Edwin Chia on 2/6/16.
//  Copyright © 2016 Edwin Chia. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var udacityButtonLoginButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func udacityLoginButtonPressed(sender: AnyObject) {
    }
    
    @IBAction func facebookLoginButtonPressed(sender: AnyObject) {
    }
    
    @IBAction func signupButtonPressed(sender: AnyObject) {
    }
    
    private func setUIEnabled(enabled: Bool) {
        
    }
}

