//
//  MatchCell.swift
//  ParseStarterProject-Swift
//
//  Created by user162638 on 4/19/20.
//  Copyright © 2020 Parse. All rights reserved.
//

import UIKit
import Parse

class MatchCell: UITableViewCell {
    
    
    @IBOutlet weak var messagesLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var matchName: UILabel!
    @IBOutlet weak var messagesTextField: UITextField!
    
    @IBAction func send(_ sender: Any) {
        var message = PFObject(className: "Message")
        message["sender"] = PFUser.current()?.objectId!
        message["recipient"] = userIdLabel.text
        message["content"] = messagesTextField.text
        
        message.saveInBackground()
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
