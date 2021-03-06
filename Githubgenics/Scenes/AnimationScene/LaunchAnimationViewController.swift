//
//  LaunchAnimation.swift
//  Githubgenics
//
//  Created by Ali Fayed on 13/01/2021.
//

import UIKit
import Lottie

class LaunchAnimationViewController: UIViewController {
    
    let animationView = AnimationView()
    static let animation = "loadingspinner"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.startAnimation ()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if UserDefaults.standard.value(forKeyPath: "outh") != nil {
                let vc = UIStoryboard.init(name: Storyboards.tabBar , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.tabBarID) as? TabBarController
                self.navigationController?.pushViewController(vc!, animated: true)
            } else {
                let vc = UIStoryboard.init(name: Storyboards.login , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.loginViewControllerID) as? LoginViewController
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
        
    private func startAnimation () {
        animationView.animation = Animation.named(LaunchAnimationViewController.animation)
        animationView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        animationView.center = view.center
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        view.addSubview(animationView)
    }
}
