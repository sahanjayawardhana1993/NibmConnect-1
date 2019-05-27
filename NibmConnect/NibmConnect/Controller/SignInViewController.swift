//
//  SignInViewController.swift
//  NibmConnect
//
//  Created by Bhanuka Isuru on 5/18/19.
//  Copyright © 2019 Bhanuka Isuru. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    

    var activityView:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

         setLogin(enabled: false)
        loginButton.backgroundColor = .clear
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.white.cgColor
        
        emailField.delegate = self
        passwordField.delegate = self
        
        emailField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
       
    }
    
    @IBAction func resetPassword(_ sender: Any) {
        
        if self.emailField.text == "" {
            let alertController = UIAlertController(title: "Error!", message: "Please enter an email.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        } else {
            Auth.auth().sendPasswordReset(withEmail: self.emailField.text!, completion: { (error) in
                var title = ""
                var message = ""
                if error != nil {
                    title = "Error!"
                    message = (error?.localizedDescription)!
                } else {
                    title = "Success!"
                    message = "Password reset email sent."
                    self.emailField.text = ""
                }
                let alertController = UIAlertController(title: "Success!", message: "Password reset email sent.", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            })
        }
    }
    
    
    @IBAction func SignUp(_ sender: Any) {
        self.performSegue(withIdentifier: "SignUp", sender: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    
    @objc func textFieldChanged(_ target:UITextField) {
        let email = emailField.text
        let password = passwordField.text
        let formFilled = email != nil && email != "" && password != nil && password != ""
       setLogin(enabled: formFilled)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Resigns the target textField and assigns the next textField in the form.
        
        switch textField {
        case emailField:
            emailField.resignFirstResponder()
            passwordField.becomeFirstResponder()
            break
        case passwordField:
            handleSignIn()
            break
        default:
            break
        }
        return true
    }
    
    func setLogin(enabled:Bool) {
        if enabled {
            loginButton.alpha = 1.0
            loginButton.isEnabled = true
        } else {
            loginButton.alpha = 0.5
            loginButton.isEnabled = false
        }
    }
    
    @IBAction func ContinueAction(_ sender: Any) {
        handleSignIn()
    }
    
    
    @objc func handleSignIn() {
        guard let email = emailField.text else { return }
        guard let pass = passwordField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: pass) { user, error in
            if error == nil && user != nil {
                self.dismiss(animated: false, completion: nil)
            } else {
                print("Error logging in: \(error!.localizedDescription)")
                self.resetForm(error: error!.localizedDescription)
            }
        }
    }
    
    func resetForm(error:String) {
        let alert = UIAlertController(title: "Error logging in", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        setLogin(enabled: true)
    
     
    }
}
