//
//  EditProfileViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Dianne Santos on 4/23/20.
//  Copyright © 2020 Parse. All rights reserved.
//

import UIKit
import Parse

class EditProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //salary range textfields
    @IBOutlet weak var salaryMin: UITextField!
    @IBOutlet weak var salaryMax: UITextField!
    
    
    //courses
    @IBOutlet weak var course1: UITextField!
    @IBOutlet weak var course2: UITextField!
    @IBOutlet weak var course3: UITextField!
    @IBOutlet weak var course4: UITextField!
    @IBOutlet weak var course5: UITextField!
    @IBOutlet weak var course6: UITextField!
    
   
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var availability: UITextField!
    @IBOutlet weak var coursesLabel: UILabel!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var profileTypeLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var updateSuccessfulLabel: UILabel!
    
    
    @IBAction func updateProfileImage(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
           if let image = info[UIImagePickerControllerOriginalImage] as! UIImage? {
               profileImage.image = image
           }
           
           self.dismiss(animated: true, completion: nil)
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateSuccessfulLabel.text = ""
        
        updateButton.layer.cornerRadius = 10
        updateButton.clipsToBounds = true
               
        
        if let availability = PFUser.current()?["availability"] as? String {
            self.availability.text = availability
        }
        
        
        if let min = PFUser.current()?["minSalary"] as? String {
            self.salaryMin.text = min
        }
        
        if let max = PFUser.current()?["maxSalary"] as? String {
            self.salaryMax.text = max
               }
        
        
        if let courses = PFUser.current()?["courses"] as? [String] {
            
            self.course1.text = courses[0];
            self.course2.text = courses[1];
            self.course3.text = courses[2];
            self.course4.text = courses[3];
            self.course5.text = courses[4];
            self.course6.text = courses[5];
            
        }
        
        
        
        if let name = PFUser.current()?["name"] as? String {
                self.nameTextField.text = name
        }
        
        
        if let bio = PFUser.current()?["biography"] as? String {
            self.bioTextField.text = bio
        }
        
        
            if let isTutor = PFUser.current()?["isTutor"] as? Bool {
                if (isTutor) {
                    self.profileTypeLabel.text = "You are a tutor"
                    self.coursesLabel.text = "Tutored Courses (6 Max)"
                    
                } else {
                    self.profileTypeLabel.text = "You are a student"
                    self.coursesLabel.text = "Desired Courses (6 Max)"
                }
            }
        
        
        if let photo = PFUser.current()?["photo"] as? PFFile {
                   photo.getDataInBackground(block: { (data, error) in
                       if let imageData = data {
                           if let downloadedImage = UIImage(data: imageData) {
                               self.profileImage.image = downloadedImage
                           }
                       }
                   })
               }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func update(_ sender: Any) {
        
        //update availability
        PFUser.current()?["availability"] = self.availability.text
        
        //update min and max salary
        PFUser.current()?["maxSalary"] = self.salaryMax.text
        PFUser.current()?["minSalary"] = self.salaryMin.text
        
        //update 6 courses
        PFUser.current()?.remove(forKey: "courses")
        
        PFUser.current()?.add(self.course1.text!, forKey:"courses")
          PFUser.current()?.add(self.course2.text!, forKey:"courses")
          PFUser.current()?.add(self.course3.text!, forKey:"courses")
          PFUser.current()?.add(self.course4.text!, forKey:"courses")
          PFUser.current()?.add(self.course5.text!, forKey:"courses")
          PFUser.current()?.add(self.course6.text!, forKey:"courses")
        
        let imageData = UIImageJPEGRepresentation(profileImage.image!,0.1)
        
          PFUser.current()?["photo"] = PFFile(name: "profile.png", data: imageData!)
        
        PFUser.current()?["name"] = self.nameTextField.text
        
         PFUser.current()?["biography"] = self.bioTextField.text
        
        PFUser.current()?.saveInBackground(block: { (success, error) in
            
            
            if error != nil {
                
                var errorMessage = "Update failed - please try again"
                
                let error = error as NSError?
                
                if let parseError = error?.userInfo["error"] as? String {
                    
                    errorMessage = parseError
                    
                }
                
                self.updateSuccessfulLabel.text = errorMessage
                
            } else {
                
                print("Updated")
                self.updateSuccessfulLabel.text = "Profile updated succesfully!"
//                self.performSegue(withIdentifier: "showSwipingViewController", sender: self)
            }
            
        })
    }
    
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
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
