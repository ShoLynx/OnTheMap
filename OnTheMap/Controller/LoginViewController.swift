//
//  ViewController.swift
//  OnTheMap
//
//  Created by Administrator on 1/7/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var udacityLogo: UIImageView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpText: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLoggingIn(false)
        
        //Hyperlink method found on https://hackingwithswift.com/example-code/system/how-to-make-tappable-links-in-nsattributedstring (Part 1/2)
        let attributedString = NSMutableAttributedString(string: "Don't have an account?  Sign up.")
        attributedString.addAttribute(.link, value: "https://www.udacity.com/account/auth#!/signup", range: NSRange(location: 24, length: 7))
        //location specifies the starting character in the string length.  length specifies how many characters the link covers from the start point.
        
        signUpText.attributedText = attributedString
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.usernameField.delegate = self
        self.passwordField.delegate = self
        self.signUpText.textAlignment = .center
        subscribeToVKeyboard()
    }
    
    //MARK: Button actions
    
    @IBAction func loginTapped (_ sender: UIButton) {
        setLoggingIn(true)
        AppClient.login(nametext: usernameField.text ?? "", passtext: passwordField.text ?? "", completion: handleLoginResponse(success:error:))
    }
    
    //Second part of 2 of the hyperlink method from hackingwithswift.
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL, options: [:])
        return false
    }
    
    //MARK: Completion handlers
    
    func handleLoginResponse(success: Bool, error: Error?) {
        if success {
            AppClient.getStudentLocation(completion: handleMapPoolResponse(pool:error:))
        } else {
            setLoggingIn(false)
            showLoginFailure(message: error?.localizedDescription ?? "")
            print(error!)
        }
    }
    
    func handleMapPoolResponse(pool: [StudentLocation]?, error: Error?) {
        if pool != nil {
            MapPool.results = pool!
            AppClient.getUserInfo(completion: handleUserDataResponse(data:error:))
        } else {
            setLoggingIn(false)
            showMapPoolFailure(message: error?.localizedDescription ?? "")
            print(error!)
        }
    }
    
    func handleUserDataResponse(data: FromParse?, error: Error?) {
        if data != nil {
            setLoggingIn(false)
            unsubscribeToVKeyboard()
            self.performSegue(withIdentifier: "completeLogin", sender: nil)
        } else {
            setLoggingIn(false)
            showDataRetrievalFailureResponse(message: error?.localizedDescription ?? "")
            print(error!)
        }
    }
    
    //MARK: Error alerts - Each of these display the parsed error messages provided by Parse/Udacity
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    func showMapPoolFailure(message: String) {
        let alertVC = UIAlertController(title: "Problem Getting Data", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    func showDataRetrievalFailureResponse(message: String) {
        let alertVC = UIAlertController(title: "Problem Getting Info", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    //MARK: Activity Indicator ruleset.  This locks interactables and displays an activity indicator until network calls complete.
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        usernameField.isEnabled = !loggingIn
        passwordField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
        activityIndicator.hidesWhenStopped = true
    }
    
    //MARK: textField properties
    
    //This function dismisses the keyboard when Return is tapped on the V-keyboard
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Get V-keyboard height
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardHeight = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardHeight.cgRectValue.height
    }
    
    //Setting up V-keyboard notifications
    
    @objc func vKeyboardWillAppear(_ notification: Notification) {
        if usernameField.isFirstResponder || passwordField.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func vKeyBoardWillDisappear(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func subscribeToVKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(vKeyboardWillAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(vKeyBoardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToVKeyboard() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}

