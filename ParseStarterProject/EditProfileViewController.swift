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
        
        
//          PFUser.current()?.addUniqueObjects(from: [displayedUserID], forKey: acceptedOrRejected
        
        if let name = PFUser.current()?["name"] as? String {
                self.nameTextField.text = name
        }
        
        
        if let bio = PFUser.current()?["biography"] as? String {
            self.bioTextField.text = bio
        }
        
        
            if let isTutor = PFUser.current()?["isTutor"] as? Bool {
                if (isTutor) {
                    self.profileTypeLabel.text = "You are a tutor"
                } else {
                    self.profileTypeLabel.text = "You are a student"
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
