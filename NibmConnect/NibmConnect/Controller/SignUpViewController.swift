//
//  SignUpViewController.swift
//  NibmConnect
//
//  Created by Bhanuka Isuru on 5/18/19.
//  Copyright © 2019 Bhanuka Isuru. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class SignUpViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var fbField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var signupButton: UIButton!
    
   
    var activityView:UIActivityIndicatorView!
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        signupButton.backgroundColor = .clear
        signupButton.layer.cornerRadius = 5
        signupButton.layer.borderWidth = 1
        signupButton.layer.borderColor = UIColor.white.cgColor
        
        
        usernameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        ageField.delegate = self
        phoneField.delegate = self
        fbField.delegate = self
        
        usernameField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        emailField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        ageField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        phoneField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        fbField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        userProfile.isUserInteractionEnabled = true
        userProfile.addGestureRecognizer(imageTap)
        userProfile.layer.cornerRadius = userProfile.bounds.height / 2
        userProfile.clipsToBounds = true

        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func openImagePicker(_ sender:Any){
        //Open Image Picker
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func textFieldChanged(_ target:UITextField) {
        let username = usernameField.text
        let email = emailField.text
        let password = passwordField.text
        let age = ageField.text
        let phone = phoneField.text
        let fbLink = fbField.text
        let formFilled = username != nil && username != "" && email != nil && email != "" && password != nil && password != "" && age != "" && phone != "" && fbLink != "" && userProfile != nil
        setSignIn(enabled: formFilled)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailField.becomeFirstResponder()
       
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        usernameField.resignFirstResponder()
        ageField.resignFirstResponder()
        phoneField.resignFirstResponder()
        fbField.resignFirstResponder()
        
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Resigns the target textField and assigns the next textField in the form.
        switch textField {
        case emailField:
            emailField.resignFirstResponder()
            passwordField.becomeFirstResponder()
            break
        case passwordField:
            passwordField.resignFirstResponder()
            usernameField.becomeFirstResponder()
            break
        case usernameField:
            usernameField.resignFirstResponder()
            ageField.becomeFirstResponder()
            break
        case ageField:
            ageField.resignFirstResponder()
            phoneField.becomeFirstResponder()
            break
        case phoneField:
            phoneField.resignFirstResponder()
            fbField.becomeFirstResponder()
            break
        case fbField:
            handleSignUp()
            break
        default:
            break
        }
        return true
    }
    
    func setSignIn(enabled:Bool) {
        if enabled {
            signupButton.alpha = 1.0
            signupButton.isEnabled = true
        } else {
            signupButton.alpha = 0.5
            signupButton.isEnabled = false
        }
    }
    
    @objc func handleSignUp() {
        guard let username = usernameField.text else { return }
        guard let email = emailField.text else { return }
        guard let pass = passwordField.text else { return }
        guard let age = ageField.text else { return }
        guard let telephone = phoneField.text else { return}
        guard let fbLink = fbField.text else { return }
        guard let image = userProfile.image else { return }
        
        setSignIn(enabled: false)

        Auth.auth().createUser(withEmail: email, password: pass) { user, error in
            if error == nil && user != nil {
                print("User created!")
                
                //Upload the profile image to  Firebase Storage
                self.uploadProfileImage(image) { url in
                    
                    if url != nil {
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = username
                        changeRequest?.photoURL = url
                        
                        changeRequest?.commitChanges { error in
                            if error == nil {
                                
                                self.saveProfile(username: username, userProfile: url!, telephone: telephone, fbLink: fbLink, age: age) { success in
                                    if success {
                                        self.dismiss(animated: true, completion: nil)
                                    }
                                }
                            } else {
                                print("Error: \(error!.localizedDescription)")
                                self.resetForm(error: error!.localizedDescription)
                            }
                        }
                    }
                    else{
                        // Error unable to upload profile image
                        self.resetForm(error: error!.localizedDescription)
                    }
                }
            } else {
                print("Error: \(error!.localizedDescription)")
                self.resetForm(error: error!.localizedDescription)
            }
        }
    }
    
    func resetForm(error:String) {
        let alert = UIAlertController(title: "Error signing up", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        setSignIn(enabled: true)
    }
    
    func uploadProfileImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("user/\(uid)")
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData) { metaData, error in
            if error == nil, metaData != nil {
                
                storageRef.downloadURL(completion: {url, error in
                    completion(url)
                })
            } else {
                completion(nil)
            }
        }
    }
    
    func saveProfile(username:String, userProfile:URL,telephone:String, fbLink:String, age: String, completion: @escaping ((_ success:Bool)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let databaseRef = Database.database().reference().child("users/profile/\(uid)")
        
        let userObject = [
            "uid":uid,
            "username": username,
            "photoURL": userProfile.absoluteString,
            "fbLink":fbLink,
            "age":age,
            "telephone":telephone
            ] as [String:Any]
        
        databaseRef.setValue(userObject) { error, ref in
            completion(error == nil)
        }
    }
    
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.userProfile.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

