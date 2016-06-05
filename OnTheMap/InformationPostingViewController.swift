//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Edwin Chia on 5/6/16.
//  Copyright © 2016 Edwin Chia. All rights reserved.
//

import UIKit

class InformationPostingViewController: UIViewController, UITextFieldDelegate {

    /* MARK: Properties */
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var cancelButtonPressed: UIButton!
    @IBOutlet weak var findOnTheMapButton: UIButton!
    
    var activityView: UIActivityIndicatorView!
    
    /* MARK: Lifecycle */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        activityView.center = view.center
    }
    
    /* MARK: Actions */
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
 
    @IBAction func findOnTheMapButtonPressed(sender: AnyObject) {
    }
    
    func setUpActivityView() {
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityView.center = view.center
        view.addSubview(activityView)
    }
}
