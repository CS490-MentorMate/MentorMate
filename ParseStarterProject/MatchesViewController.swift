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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFUser.query()
        query?.whereKey("accepted", contains: PFUser.current()?.objectId)
        query?.whereKey("objectId", containedIn: PFUser.current()?["accepted"] as! [String])
        
        query?.findObjectsInBackground(block: { (objects, error) in     //gets an array of objects; array name: objects
            print("objects: \(objects)")
            if let users = objects {        //puts the objects array into users and checks if the array exists
                print("here 1")
                for object in users {
                    print("here 2")
                    if let user = object as? PFUser {
                        print("here 3")
                        let imageFile = user["photo"] as! PFFile
                        print("file: \(imageFile)")
                        imageFile.getDataInBackground { (data, error) in
                            if let imageData = data {
                                print("data: \(imageData)")
                                self.images.append(UIImage(data: imageData)!)
                            }
                        }
                        if let name = user["username"] as? String {
                            print(name)
                            self.names.append(name)
                        }
                        if let objectId = user.objectId as? String {
                            self.objectIds.append(objectId)
                        }
                    }
                }
                self.matchesTable.reloadData()
            }
        })
        //print("match: \(matchedUsers)")
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(names.count)
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = matchesTable.dequeueReusableCell(withIdentifier: "MatchCell") as! MatchCell
        
        print("name: \(names[indexPath.row])")
        
        cell.profilePicture.image = images[indexPath.row]
        cell.matchName.text = names[indexPath.row]
        
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
