//
//  ProfileViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/02/2021.
//

import UIKit
import Alamofire
import SwiftyJSON
import AuthenticationServices

class ProfileViewController: UIViewController {
    
    // data model
    var userRepository = [Repository]()
    var selectedRepository: Repository?
    var profileTableData = [ProfileTableData]()
    let footer = UIView ()
    // spinner
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) as UIActivityIndicatorView
    // button if not signed in
    let signInwithGithubButton: UIButton = {
        let button = UIButton()
        button.setTitle(Titles.signinWith, for: .normal)
        button.backgroundColor = UIColor(named: "Color")
        button.setTitleColor(.systemBackground, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.addTarget(self, action: #selector(didTapSignIn),for: .touchUpInside)
        return button
    }()
    //  refresh control
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.gray
        return refreshControl
    }()
    // check for token
    var isLoggedIn: Bool {
        if TokenManager.shared.fetchAccessToken() != nil {
            return true
        }
        return false
    }
    
     // IBOutlets
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userLogin: UILabel!
    @IBOutlet weak var userLocation: UILabel!
    @IBOutlet weak var userBio: UILabel!
    @IBOutlet weak var Header: UIView!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userFollowers: UILabel!
    @IBOutlet weak var userFollowing: UILabel!

    //MARK:- LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isLoggedIn {
            signInwithGithubButton.isHidden = true
        } else {
            tableView.isHidden = true
            signInwithGithubButton.isHidden = false
        }
        tableView.addSubview(refreshControl)
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.RepositoriesViewTitle)", Image: "Repositories" ))
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.Startted)", Image: "Startted" ))
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.Organizations)", Image: "Organizations"))
        tableView.tableHeaderView = Header
        tableView.tableHeaderView?.backgroundColor = UIColor(named: "ViewsColorBallet")
        tableView.tableFooterView = footer
        renderUserProfile ()
        view.addSubview(signInwithGithubButton)
        self.tabBarItem.title = Titles.Profile
        tableView.addSubview(refreshControl)
        title = Titles.BookmarksViewTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = Titles.Profile
        tabBarController?.navigationItem.rightBarButtonItem = settingsButton
//        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLayoutSubviews() {
        signInwithGithubButton.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 70)
    }
    
    // segue to welcome screen
    @objc func didTapSignIn () {
        let vc = UIStoryboard.init(name: Storyboards.login, bundle: Bundle.main).instantiateViewController(withIdentifier: ID.loginViewControllerID) as? LoginViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func didTapSettingsButton(_ sender: UIBarButtonItem) {
        let vc = UIStoryboard.init(name: Storyboards.settings , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.settingsViewControllerID) as? SettingsViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}

//MARK:-  Profile Table

extension ProfileViewController : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileTableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = profileTableData[indexPath.row].cellHeader
        cell.imageView?.image = UIImage(named: profileTableData[indexPath.row].Image)
        cell.imageView?.layer.cornerRadius = 10
        cell.imageView?.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            let vc = UIStoryboard.init(name: Storyboards.userRepos , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.userRepositoryViewControllerID) as? UserRepositoryViewController
            self.navigationController?.pushViewController(vc!, animated: true)
            
        } else if indexPath.row == 1 {
            let vc = UIStoryboard.init(name: Storyboards.userStartted , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.userStartedViewControllerID) as? UserStartedViewController
            self.navigationController?.pushViewController(vc!, animated: true)
            
        } else if indexPath.row == 2 {
            let vc = UIStoryboard.init(name: Storyboards.userOrgs , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.userOrgsViewControllerID) as? UserOrgsViewController
            self.navigationController?.pushViewController(vc!, animated: true)
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        HapticsManger.shared.selectionVibrate(for: .soft)
    }
    
}

//MARK:- Fetch User Profile

extension ProfileViewController {
    
    func renderUserProfile () {
        session.request(GitRouter.gitAuthUser).responseJSON { (response) in
            switch response.result {
            case .success(let responseJSON) :
                let recievedJson = JSON (responseJSON)
                self.userName.text = recievedJson["\(AuthenticatedUserInfo.userName)"].stringValue
                let avatar = recievedJson["\(AuthenticatedUserInfo.userAvatar)"].stringValue
                self.userAvatar.kf.setImage(with: URL(string: avatar), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
                self.userAvatar.layer.masksToBounds = false
                self.userAvatar.layer.cornerRadius = self.userAvatar.frame.height/2
                self.userAvatar.clipsToBounds = true
                self.userFollowers.text = recievedJson["\(AuthenticatedUserInfo.userFollowers)"].stringValue
                self.userFollowing.text = recievedJson["\(AuthenticatedUserInfo.userFollowing)"].stringValue
                self.userBio.text = recievedJson["\(AuthenticatedUserInfo.userBio)"].stringValue
                self.userLogin.text = recievedJson["\(AuthenticatedUserInfo.userLoginName)"].stringValue
                self.userLocation.text = recievedJson["\(AuthenticatedUserInfo.userLocation)"].stringValue
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK:- Profile Model

struct ProfileTableData {
    let cellHeader: String
    let Image: String
}
