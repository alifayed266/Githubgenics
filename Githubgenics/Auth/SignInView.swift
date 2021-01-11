//
//  LogInClass.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/12/2020.
//

import UIKit
import Firebase

class SignInView: UIViewController {
        
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        navigationController?.isToolbarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
    }
//    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
        navigationController?.isToolbarHidden = true

    }
//    
    @IBAction func SignIn(_ sender: UIButton) {
        if let email = Email.text, let password = Password.text {
            UserDefaults.standard.set(Email.text, forKey: "email")
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                guard self != nil else { return }
                if let e = error {
                    print(e.localizedDescription)
                    self!.ErrorSigninAlert ()
                } else {
                    self?.performSegue(withIdentifier: K.SignInSegue, sender: self)
                }
            }
        }
        
    }
    
    func ErrorSigninAlert () {
        let alert = UIAlertController(title: "Enter Sign in", message: "The password is invalid or you don't have the password", preferredStyle: .alert)
        let action = UIAlertAction(title: "Try Again", style: .default) { (action) in
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
}
