//
//  MatchCell.swift
//  ParseStarterProject-Swift
//
//  Created by user162638 on 4/19/20.
//  Copyright © 2020 Parse. All rights reserved.
//

import UIKit

class MatchCell: UITableViewCell {
    
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var matchName: UILabel!
    @IBOutlet weak var lastMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
