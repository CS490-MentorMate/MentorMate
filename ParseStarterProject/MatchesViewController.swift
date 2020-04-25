//
//  MatchesViewController.swift
//  ParseStarterProject-Swift
//
//  Created by user162638 on 4/19/20.
//  Copyright © 2020 Parse. All rights reserved.
//

import UIKit
import Parse

class MatchesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var matchesTable: UITableView!
    
    
    var images = [UIImage]()
    
    var names = [String]()
    
    var objectIds = [String]()
    
    var messages = [String]()
    
    var usernames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFUser.query()
        query?.whereKey("accepted", contains: PFUser.current()?.objectId)
        query?.whereKey("objectId", containedIn: PFUser.current()?["accepted"] as! [String])
        
        query?.findObjectsInBackground(block: { (objects, error) in     //gets an array of objects; array name: objects

            if let users = objects {        //puts the objects array into users and checks if the array exists
                for object in users {
                    if let user = object as? PFUser {
                        let imageFile = user["photo"] as! PFFile
                        imageFile.getDataInBackground { (data, error) in
                            if let imageData = data {
//                                self.images.append(UIImage(data: imageData)!)
//                                self.objectIds.append(user.objectId!)
//                                self.names.append(user.username!)
//                                self.matchesTable.reloadData();
//                                
                                let messageQuery = PFQuery(className: "Message")
                                messageQuery.whereKey("recipient", equalTo: (PFUser.current()?.objectId!)!)
                                messageQuery.whereKey("sender", equalTo: user.objectId!)
                                messageQuery.findObjectsInBackground { (objects, error) in
                                    var messageText = "No message from this user."
                                    if let objects = objects {
                                        for message in objects {
                                                if let messageContent = message["content"] as? String {
                                                    messageText = messageContent
                                                }
                                        }
                                    }
                                    
                                    print(messageText)
                                    
                                    self.messages.append(messageText)
                                    self.images.append(UIImage(data: imageData)!)
                                    self.objectIds.append(user.objectId!)
                                    self.usernames.append(user.username!)
                                    self.names.append(user["name"] as! String)
                                    self.matchesTable.reloadData()
                                    
                                }
                                
                            }
                        }
//                        if let name = user["username"] as? String {
//                            self.names.append(name)
//                            self.matchesTable.reloadData();
//                        }
//                        if let objectId = user.objectId as? String {
//                            self.objectIds.append(objectId)
//                            self.matchesTable.reloadData();
//                        }
                    }
                }
               // self.matchesTable.reloadData()
            }
        })
        //print("match: \(matchedUsers)")
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("name count: \(names.count)")
        return images.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = matchesTable.dequeueReusableCell(withIdentifier: "MatchCell") as! MatchCell
        
        print("name: \(names[indexPath.row])")
        
        cell.profilePicture.image = images[indexPath.row]
        cell.matchName.text = names[indexPath.row]
        cell.usernameLabel.text = usernames[indexPath.row]
        cell.userIdLabel.text = objectIds[indexPath.row]
        cell.messagesLabel.text = messages[indexPath.row]
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
