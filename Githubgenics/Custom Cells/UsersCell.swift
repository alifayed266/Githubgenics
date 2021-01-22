//
//  TableViewCell.swift
//  Githubgenics
//
//  Created by Ali Fayed on 24/12/2020.
//

import UIKit
import CoreData

class UsersCell: UITableViewCell {
  
    static let identifier = "User"
    static let profileImageSize: CGSize = CGSize(width: 50, height: 50)

    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var UserNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

 
    func CellData(with model: UsersStruct) {
        self.UserNameLabel.text = model.login.capitalized
        let url = model.avatar_url
        self.ImageView.kf.setImage(with: URL(string: url), placeholder: nil, options: [.transition(.fade(0.7))])
        self.ImageView.layer.cornerRadius = UsersCell.profileImageSize.width / 2.0
        ImageView.contentMode = .scaleAspectFill
        ImageView.layer.masksToBounds = false
        ImageView.layer.cornerRadius = ImageView.frame.height/2
        ImageView.clipsToBounds = true
        UserNameLabel.layer.masksToBounds = false
        UserNameLabel.layer.cornerRadius = UserNameLabel.frame.height/2
        UserNameLabel.clipsToBounds = true
      
    }










}