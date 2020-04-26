//
//  ProfileViewController.swift
//  ParseStarterProject-Swift
//
//  Created by user162638 on 4/24/20.
//  Copyright © 2020 Parse. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var courseLabel1: UILabel!
    @IBOutlet weak var courseLabel2: UILabel!
    @IBOutlet weak var courseLabel3: UILabel!
    @IBOutlet weak var courseLabel4: UILabel!
    @IBOutlet weak var courseLabel5: UILabel!
    @IBOutlet weak var courseLabel6: UILabel!
    @IBOutlet weak var lowerSalaryLabel: UILabel!
    @IBOutlet weak var upperSalaryLabel: UILabel!
    @IBOutlet weak var availabilityLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    var user = PFUser()
    var picture = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = user["name"] as! String
        usernameLabel.text = user["username"] as! String
        bioLabel.text = user["biography"] as! String
        let courses = user["courses"] as! [String]
        if courses[0] == "none" {
            courseLabel1.text = "-"
        }
        else {
            courseLabel1.text = courses[0]
        }
        if courses[1] == "none" {
            courseLabel2.text = "-"
        }
        else {
            courseLabel2.text = courses[1]
        }
        if courses[2] == "none" {
            courseLabel3.text = "-"
        }
        else {
            courseLabel3.text = courses[2]
        }
        if courses[3] == "none" {
            courseLabel4.text = "-"
        }
        else {
            courseLabel4.text = courses[3]
        }
        if courses[4] == "none" {
            courseLabel5.text = "-"
        }
        else {
            courseLabel5.text = courses[4]
        }
        if courses[5] == "none" {
            courseLabel6.text = "-"
        }
        else {
            courseLabel6.text = courses[5]
        }
        lowerSalaryLabel.text = user["minSalary"] as! String
        upperSalaryLabel.text = user["maxSalary"] as! String
        availabilityLabel.text = user["availability"] as! String
        profilePicture.image = picture
    // Do any additional setup after loading the view.
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
