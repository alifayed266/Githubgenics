//
//  CommitsViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 24/01/2021.
//

import UIKit

class CommitsViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    var commits: [Commit] = []
    var selectedRepository: Repository?
    let loadingIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
      super.viewDidLoad()
      loadingIndicator.center = view.center
      view.addSubview(loadingIndicator)
      fetchCommitsForRepository()
        searchBar.delegate = self
    }

    func fetchCommitsForRepository() {
      loadingIndicator.startAnimating()
      guard let repository = selectedRepository else {
        return
      }
        GithubRouter.shared.fetchCommits(for: repository.fullName) { [self] commits in
        self.commits = commits
        loadingIndicator.stopAnimating()
        tableView.reloadData()
      }
    }
  }

  // MARK: - UITableViewDataSource
  extension CommitsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return commits.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "CommitCell", for: indexPath)
      let commit = commits[indexPath.row]
      cell.textLabel?.text = commit.authorName
      cell.detailTextLabel?.text = commit.message
      return cell
    }

}
