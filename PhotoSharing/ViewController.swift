//
//  ViewController.swift
//  Instagram
//
//  Created by Julie Wang on 24/7/2018.
//  Copyright © 2018 Julie Wang. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    var signupModeActive = true // sign up or log in mode
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signupOrLoginButton: UIButton!
    @IBOutlet weak var switchLoginModeButton: UIButton!
    @IBOutlet weak var switchLoginModeLabel: UILabel!
    
    func displayAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func stopSpinner(activityIndicator: UIActivityIndicatorView) {
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    func signup(activityIndicator: UIActivityIndicatorView) {
        let user = PFUser()
        user.username = email.text
        user.password = password.text
        user.email = email.text
        
        user.signUpInBackground { (success, error) in
            self.stopSpinner(activityIndicator: activityIndicator)
            
            if let error = error {
                self.displayAlert(title: "Could not sign you up", message: error.localizedDescription)
            } else {
                print("Signed up")
                self.performSegue(withIdentifier: "showUserTable", sender: self)
            }
        }
    }
    
    func login(activityIndicator: UIActivityIndicatorView) {
        PFUser.logInWithUsername(inBackground: email.text!, password: password.text!) { (user, error) in
            self.stopSpinner(activityIndicator: activityIndicator)
            
            if user != nil {
                print("Login successful")
                self.performSegue(withIdentifier: "showUserTable", sender: self)
            } else {
                var errorText = "Unknown error: please try again"
                if let error = error {
                    errorText = error.localizedDescription
                }
                self.displayAlert(title: "Could not log in", message: errorText)
            }
        }
    }
    
    @IBAction func signupOrLogin(_ sender: Any) {
        // if form is incomplete, display alert
        if email.text == "" || password.text == "" {
            displayAlert(title: "Error in form", message: "Please enter an email and password")
        } else {
            // start spinner
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            if (signupModeActive) {
                signup(activityIndicator: activityIndicator)
            }
            else {
                login(activityIndicator: activityIndicator)
            }
        }
    }
    
    @IBAction func switchLoginMode(_ sender: Any) {
        if (signupModeActive) {
            signupModeActive = false
            signupOrLoginButton.setTitle("Log In", for: [])
            switchLoginModeButton.setTitle("Sign Up", for: [])
            switchLoginModeLabel.text = "Don't have an account?"
        } else {
            signupModeActive = true
            signupOrLoginButton.setTitle("Sign Up", for: [])
            switchLoginModeButton.setTitle("Log In", for: [])
            switchLoginModeLabel.text = "Already have an account?"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil {
            print("Already logged in")
            performSegue(withIdentifier: "showUserTable", sender: self)
        }
        self.navigationController?.navigationBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

