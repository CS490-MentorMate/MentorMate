//
//  SwipingViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Siddharth Dhar on 4/15/20.
//  Copyright © 2020 Parse. All rights reserved.
//

import UIKit
import Parse

class SwipingViewController: UIViewController {

    @IBOutlet weak var swipeImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var coursesLabel: UILabel!
    
    var displayedUserID = ""

    
    @objc func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        
        let translation = gestureRecognizer.translation(in: view)
        
        let label = gestureRecognizer.view!
        
        label.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: self.view.bounds.height / 2 + translation.y)
        
        let xFromCenter = label.center.x - self.view.bounds.width / 2
        
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 200)
        
        let scale = min(abs(100 / xFromCenter), 1)
        
        var stretchAndRotation = rotation.scaledBy(x: scale, y: scale) // rotation.scaleBy(x: scale, y: scale) is now rotation.scaledBy(x: scale, y: scale)

        
        label.transform = stretchAndRotation
        
        
        if gestureRecognizer.state == UIGestureRecognizer.State.ended {
            
            var acceptedOrRejected = ""
            
            if label.center.x < 100 {
                
                acceptedOrRejected = "rejected"
                
            } else if label.center.x > self.view.bounds.width - 100 {
                
                acceptedOrRejected = "accepted"
                
            }
            
            if acceptedOrRejected != "" && displayedUserID != "" {
                
                PFUser.current()?.addUniqueObjects(from: [displayedUserID], forKey: acceptedOrRejected)
                
                PFUser.current()?.saveInBackground(block: { (success, error) in
                
                    
                    print(PFUser.current())
                    
                    self.updateImage()
                    
                })
                
                
                
            }
            
            rotation = CGAffineTransform(rotationAngle: 0)
            
            stretchAndRotation = rotation.scaledBy(x: 1, y: 1) // rotation.scaleBy(x: scale, y: scale) is now rotation.scaledBy(x: scale, y: scale)

            
            label.transform = stretchAndRotation
            
            label.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
            
        }
        
    }
    func updateImage() {
        
        let query = PFUser.query()
        
        print(PFUser.current())
        
        query?.whereKey("isTutor", notEqualTo: (PFUser.current()?["isTeaching"]))
        
        query?.whereKey("isTeaching", notEqualTo: (PFUser.current()?["isTutor"]))
        
        var ignoredUsers = [""]
        
        if let acceptedUsers = PFUser.current()?["accepted"] {
            
            ignoredUsers += acceptedUsers as! Array
            
        }
        
        if let rejectedUsers = PFUser.current()?["rejected"] {
            
            ignoredUsers += rejectedUsers as! Array
            
        }
        
        query?.whereKey("objectId", notContainedIn: ignoredUsers)
        
        query?.whereKey("objectId", notEqualTo: PFUser.current()?["objectId"])
        
        /*var userCourses = [String]()
        var i = 0
        for course in PFUser.current()?["courses"] as! [String] {
            if course == "none" {
              userCourses[i] = "none1"
            }
            else {
              userCourses[i] = course
            }
            i = i + 1
        }
        let queryArray = [PFUser.query()]
        i = 0
        for course in userCourses {
            queryArray[i]?.whereKey("courses", contains: userCourses[i])
        }
        
        PFQuery.orQuery(withSubqueries: queryArray?)*/
        
        if let latitude = (PFUser.current()?["location"] as AnyObject).latitude {
            if let longitude = (PFUser.current()?["location"] as AnyObject).longitude {
                query?.whereKey("location", withinGeoBoxFromSouthwest: PFGeoPoint(latitude: latitude - 1, longitude: longitude - 1), toNortheast: PFGeoPoint(latitude: latitude + 1, longitude: longitude + 1))
            }
        }
        
        query?.limit = 1
        
        query?.findObjectsInBackground(block: { (objects, error) in
            
            if let users = objects {
                
                
                for object in users {
                 
                    
                    if let user = object as? PFUser {
                        
                        self.displayedUserID = user.objectId!
                        
                        let imageFile = user["photo"] as! PFFile
                        
                        imageFile.getDataInBackground(block: { (data, error) in
                            
                            if error != nil {
                                
                                print(error)
                                
                            }
                            
                            if let imageData = data {
                                
                                self.swipeImage.image = UIImage(data: imageData)
                                self.nameLabel.text = user["name"] as! String
                                self.bioLabel.text = user["biography"] as! String
                                var courseListString = ""
                                let courseListArray = user["courses"] as! [String]
                                for course in courseListArray {
                                    if (course != "none") {
                                        courseListString += course + " "
                                    }
                                }
                                self.coursesLabel.text = courseListString
                            }
                            
                            
                        })
                        
                    }
                    
                }
                
                
            }
            
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bioLabel.lineBreakMode = .byWordWrapping
        bioLabel.numberOfLines = 0
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.wasDragged(gestureRecognizer:)))
        
        swipeImage.isUserInteractionEnabled = true
        
        swipeImage.addGestureRecognizer(gesture)
        
        PFGeoPoint.geoPointForCurrentLocation { (geopoint, error) in
            if let geopoint = geopoint {
                PFUser.current()?["location"] = geopoint
                PFUser.current()?.saveInBackground()
            }
        }
        
        updateImage()
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logoutSegue" {
            PFUser.logOut()
            print("logout worked")
        }
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
