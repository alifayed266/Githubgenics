//
//  DetailViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 21/12/2020.
//

import UIKit
import SkeletonView
import Kingfisher

//MARK:- Main Class

class DetailViewController: UIViewController  {
    
    var userRepository : [UserRepository] = []
    var passedUser : Users?
    var defaults = UserDefaults.standard
    
    var setBookmarkButtonState: String = "off" {
        willSet {
            if newValue == "on" {
                bookmarkButton.setBackgroundImage(UIImage(named: "like"), for: .normal)
                Save().user(login: (passedUser?.userName)!, avatar_url: (passedUser?.userAvatar)!, html_url: (passedUser?.userURL)!)
            }
            else { bookmarkButton.setBackgroundImage(UIImage(named: "unlike"), for: .normal)

            }
        }
    }

    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userFollowers: UILabel!
    @IBOutlet weak var userFollowing: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationItem.title = "Detail View".localized()
        loadUserProfileData ()
        loadTheButtonWithSavedState ()
        loadUserRepository()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = true
    }
        
}

    
