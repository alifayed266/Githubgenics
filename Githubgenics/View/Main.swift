//
//  ViewController2.swift
//  Githubgenicsk
//
//  Created by Ali Fayed on 21/12/2020.
//

import UIKit

class Main: UIViewController {
    
    @IBOutlet weak var Button: UIButton!
    @IBOutlet weak var SignIn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

        
    }
    
    @IBAction func AutoSignIn(_ sender: Any) {
       if UserDefaults.standard.value(forKeyPath: "email") != nil {
            performSegue(withIdentifier: "Default", sender: self)
       } else {
        performSegue(withIdentifier: "Nil", sender: self)
       }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        navigationController?.isToolbarHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = false
        
    }
    
}