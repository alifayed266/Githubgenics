//
//  exTableView.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/01/2021.
//

import UIKit
import SafariServices


extension RepositoriesListViewController {
    
    
      override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return fetchedRepositories.count
      }

      override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.repositoriesCell, for: indexPath) as? ReposCell
          cell?.CellData(with: fetchedRepositories[indexPath.row])
          return cell!
      }
      
      override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 120
     }
      
      override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          tableView.deselectRow(at: indexPath, animated: true)
          let url = fetchedRepositories[indexPath.row].repositoryURL
          let vc = SFSafariViewController(url: URL(string: url)!)
          DispatchQueue.main.async {
              tableView.isHidden = false
          }
          present(vc, animated: true)

      }
      
      override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
          let important = importantAction(at: indexPath)
          return UISwipeActionsConfiguration(actions: [important])
      }
      
      func importantAction(at indexPath: IndexPath) -> UIContextualAction {
          let action = UIContextualAction(style: .normal, title: "Bookmark") { [self] (action, view, completion) in
              let index = fetchedRepositories[indexPath.row]
            Save().repository(name: index.repositoryName, desc: index.repositoryDescription, language: index.repositoryLanguage!, stars: index.repositoryStars, url: index.repositoryURL)
          }
          action.image = #imageLiteral(resourceName: "like")
          action.backgroundColor = .gray
          return action
      }
    
}
