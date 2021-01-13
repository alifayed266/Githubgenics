//
//  TableViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/12/2020.
//

import UIKit
import Firebase
import SkeletonView
import Alamofire
import Kingfisher
import CoreData
import SwipeCellKit

class UsersView: UITableViewController {

    var UsersAPIStruct = [UsersStruct]()
    var checkmarks = [Int : Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        UIView.setAnimationsEnabled(false)
        tableView.rowHeight = 100.0
        navigationItem.hidesBackButton = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        FetchUsers ()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isToolbarHidden = false
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    // MARK: - Sign Out Auth
    
    @IBAction func SignOuut(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: Main.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
            UserDefaults.standard.removeObject(forKey: "email")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            SignOutError()
        }
    }
    
    // MARK: - GitHubURL Button
    
    @IBAction func GitHubURL(_ sender: UIBarButtonItem) {
        let APIurl = ("https://github.com/")
        guard let url = URL(string: APIurl)
        else {
            return }
        let vc = WebManger(url: url, title: "Google")
        let navVc = UINavigationController(rootViewController: vc)
        present(navVc, animated: true)
    }
    
    // MARK: - TableView Methods
    
    @IBAction func Refresh(_ sender: UIRefreshControl) {
        sender.endRefreshing()
        FetchUsers ()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UsersAPIStruct.count
    }
     
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UsersCell 
        let APIImageurl = "https://avatars0.githubusercontent.com/u/\(UsersAPIStruct[indexPath.row].id)?v=4"
        cell.UserNameLabel?.text = UsersAPIStruct[indexPath.row].login.capitalized
        cell.ImageView.kf.setImage(with: URL(string: APIImageurl), placeholder: nil, options: [.transition(.fade(0.7))])
        return cell
        
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destnation = segue.destination as? DetailView {
            destnation.Users = UsersAPIStruct[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let postion = scrollView.contentOffset.y
        if postion > (tableView.contentSize.height-100-scrollView.frame.size.height) {
            FetchMoreUsers ()
            DisplaySpinner ()
        }
        

     
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            cell.alpha = 0
//        let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 20, 0)
//        cell.layer.transform = transform
//        
//        UIView.animate(withDuration: 1.0) {
//            cell.alpha = 1.0
//            cell.layer.transform = CATransform3DIdentity
//        }
//        }
 
        let LastSection = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: LastSection) - 20
        if indexPath.section ==  LastSection && indexPath.row == lastRowIndex {

        }
        
        if indexPath.row == UsersAPIStruct.count - 1 {
    
        }

    }
    
    
    
    // MARK: - Fetch Data From GitHubAPI
    
   private var Users : [UsersStruct] = []
   var isPaginating = false
    
    func Fetch(pagination: Bool = false, since : Int , page : Int , complete: @escaping (Result<[UsersStruct], Error>) -> Void ) {

       if pagination {
           isPaginating = true
       }
       DispatchQueue.global().asyncAfter(deadline: .now() + (pagination ? 3 : 2)) {
        let url = "https://api.github.com/users?since=\(since)&per_page=\(page)"
        
        AF.request(url , method: .get).responseJSON { (response) in
               do {
                   let users = try JSONDecoder().decode([UsersStruct].self, from: response.data!)
                   self.Users = users
                self.tableView.reloadData()
                self.dismiss(animated: false, completion: nil)

                print("Main Fetch")
               } catch {
                   let error = error
                   print(error.localizedDescription)
               }
           }
           complete(.success( pagination ? self.Users : self.Users ))
        
           if pagination {
               self.isPaginating = false
           }
       }
   }

    
    // MARK: - Loaders
    
    func LoadingIndicator() {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    
  
    

    func Error () {
        let alert = UIAlertController(title: "Server isn't stable", message: "Pull to refresh to load the data", preferredStyle: .alert)
        let action = UIAlertAction(title: "Try Again", style: .default) { (action) in
            self.Fetch(pagination: false, since: 1, page: 20) { (result) in
                switch result {
                case.success( let UsersAPIStruct):
                    self.UsersAPIStruct.append(contentsOf: UsersAPIStruct)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.tableView.reloadData()
                    }
                case.failure(_):
                    self.Error()
                }
            }        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func SkeletonViewLoader () {
        tableView.isSkeletonable = true
        tableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.tableView.stopSkeletonAnimation()
            self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        }
    }
    
    func SignOutError () {
        let alert = UIAlertController(title: "Error Sign Out", message: "check your internet", preferredStyle: .alert)
        let action = UIAlertAction(title: "Try Again", style: .default) { (action) in
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func DisplaySpinner () {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        self.tableView.tableFooterView = spinner
        self.tableView.tableFooterView?.isHidden = false
    }
    
    
    func FetchUsers () {
        AF.request("https://api.github.com/users", method: .get).responseJSON { (response) in
            do {
                if let safedata = response.data {
                    let repos = try JSONDecoder().decode([UsersStruct].self, from: safedata)
                    self.UsersAPIStruct = repos
                    self.tableView.reloadData()
                    self.SkeletonViewLoader ()
                }
            }
            catch {
                let error = error
                print(error.localizedDescription)
//                self.ErroLoadingRepos ()
                self.Error()
            }
        }
    }
    
    func FetchMoreUsers () {
        guard !isPaginating else {
            return
        }
        Fetch(pagination: true, since: Int.random(in: 40 ... 5000 ), page: 10 ) { [weak self] result in
            DispatchQueue.main.async {
                self?.tableView.tableFooterView = nil
            }
            switch result {
            case .success(let UsersAPIStruct):
                self?.UsersAPIStruct.append(contentsOf: UsersAPIStruct)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case .failure(_):
                self!.Error()
            break
            }
        }
    }

}

