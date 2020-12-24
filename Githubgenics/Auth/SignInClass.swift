//
//  LogInClass.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/12/2020.
//

import UIKit
import Firebase

class SignInClass: UIViewController {
    
    
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    
    @IBAction func SignIn(_ sender: UIButton) {
        
        if let email = Email.text, let password = Password.text {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                guard self != nil else { return }
            if let e = error {
                print(e.localizedDescription)
                self?.performSegue(withIdentifier: "error", sender: self)
            } else {
                print("Sign In Complete")
                self?.performSegue(withIdentifier: K.SignIn, sender: self)
            }
        }
    }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isToolbarHidden = true

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isToolbarHidden = false
        
    }
}
