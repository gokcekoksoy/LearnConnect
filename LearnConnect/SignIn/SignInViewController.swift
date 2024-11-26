//
//  SignInViewController.swift
//  LearnConnect
//
//  Created by Gokce Koksoy on 22.11.2024.
//

import UIKit
import FirebaseAuth

final class SignInViewController: UIViewController {
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }

    @IBAction func signInTapped(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            makeAlert(titleInput: "Error!", messageInput: "User name or password is empty")
            return
        }
        
        if !email.isEmpty, !password.isEmpty {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] (authdata, error) in
                if error != nil {
                    self?.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    self?.performSegue(withIdentifier: "toCourseVC", sender: nil)
                }
            }
        }
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            makeAlert(titleInput: "Error!", messageInput: "User name or password is empty")
            return
        }
        
        if !email.isEmpty, !password.isEmpty {
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] (authdata, error) in
                if error != nil {
                    self?.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    self?.performSegue(withIdentifier: "toCourseVC", sender: nil)
                }
            }
        }
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
}
