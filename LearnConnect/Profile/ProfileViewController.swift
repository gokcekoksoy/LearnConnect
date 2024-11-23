//
//  ProfileViewController.swift
//  LearnConnect
//
//  Created by Gokce Koksoy on 22.11.2024.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserProfile()
    }
    
    func loadUserProfile() {
        guard let user = Auth.auth().currentUser else { return }
        nameLabel.text = "Name: \(user.displayName ?? "No name")"
        emailLabel.text = "E-mail: \(user.email ?? "No e-mail")"
    }

    @IBAction func signOutTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toSignInViewController", sender: nil)
        } catch {
            print("error")
        }
        
    }
}
