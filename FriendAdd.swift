//
//  FriendAdd.swift
//  MyFriends
//
//  Created by Mitch on 2019-10-04.
//  Copyright © 2019 Mitch. All rights reserved.
//

import UIKit

protocol FriendAddDelegate: AnyObject{
    func addTaskDidCancel(_ controller: UIViewController)
    func addTask(_ conroller: UIViewController, didSave item: Friend)
}



class FriendAdd: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    weak var delegate: FriendAddDelegate?
    var m: DataModelManager!
    var photo: UIImage?
    
    @IBOutlet weak var FirstName: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var FriendAge: UITextField!
    @IBOutlet weak var FriendCity: UITextField!
    @IBOutlet weak var ErrorMessage: UILabel!
    
    @IBOutlet weak var pickPhoto: UIImageView!
    @IBOutlet weak var addPhoto: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         FirstName.becomeFirstResponder()
     }
     
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func getPhotoWithCameraOrPhotoLibrary() {
        
        // Create the image picker controller
        let c = UIImagePickerController()
        
        // Determine what we can use...
        // Prefer the camera, but can use the photo library
        c.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary
        
        c.delegate = self
        c.allowsEditing = false
        // Show the controller
        present(c, animated: true, completion: nil)
    }

    @IBAction func cancel(_ sender: Any) {
        delegate?.addTaskDidCancel(self)
    }
    
    @IBAction func save(_ sender:UIBarButtonItem){
        view.endEditing(false)
        ErrorMessage.text?.removeAll()
        
        if FirstName.text!.isEmpty{
            ErrorMessage.text = "Invalid Friend Name"
            return
        }
        
        if LastName.text!.isEmpty{
            ErrorMessage.text = "Invalid Friend's Last Name"
            return
        }
        
        if FriendAge.text!.isEmpty{
            ErrorMessage.text = "Invalid Age"
            return
        }
        
        if FriendCity.text!.isEmpty{
            ErrorMessage.text = "Invalid City Name"
            return
        }
        
        var agePerson: Int = 0
        
        if let ageValue = Int(FriendAge.text!){
            agePerson = ageValue
            
            if ageValue < 0 || ageValue > 100 {
                ErrorMessage.text = "Invalid Age"
                return
            }
        }
        
       
        
        ErrorMessage.text = "Attempting to save ..."
        if pickPhoto.image == nil {
            let newFriend = Friend(id: 0, givenName: FirstName.text!, familyName: LastName.text!, age: agePerson, city: FriendCity.text!, imageName: "")
            delegate?.addTask(self, didSave: newFriend)
        }
        else {
            var image: UIImage?
            var fileName: String
            repeat {
                let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
                fileName = String((0..<25).map{ _ in letters.randomElement()! })
                image = m.loadImage(fileName: fileName)
            } while image != nil

            m.saveImage(imageName: fileName, image: pickPhoto.image!)
            let newFriend = Friend(id: 0, givenName: FirstName.text!, familyName: LastName.text!, age: agePerson, city: FriendCity.text!, imageName: fileName)
            delegate?.addTask(self, didSave: newFriend)
            
        }
    }
    
    //adjusted from any to UIBUTTON
    @IBAction func addPhoto(_ sender: UIButton) {
        getPhotoWithCameraOrPhotoLibrary()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        pickPhoto.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
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
