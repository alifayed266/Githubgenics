//
//  DetailCellTableViewCell.swift
//  Githubgenics
//
//  Created by Ali Fayed on 25/12/2020.
//

import UIKit

class ReposCell: UITableViewCell {

    @IBOutlet weak var RepoNameLabel: UILabel!
    @IBOutlet weak var Description: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}