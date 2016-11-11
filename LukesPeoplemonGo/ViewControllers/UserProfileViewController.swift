//
//  UserProfileViewController.swift
//  LukesPeoplemonGo
//
//  Created by Lucas Lell on 11/8/16.
//  Copyright © 2016 Luuke192. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var fullNameText: UITextField!
    
    
    var gestureRecognizer: UITapGestureRecognizer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = UserStore.shared.user{
            
            
            fullNameText.text = user.fullName
            
            
            // Do any additional setup after loading the view.
            
            //if already has image we want to show it--if not we want to hide it
            if let image = Utils.stringToImage(str: user.avatarBase64){
                imageView.image = image
                addGestureRecognizer()
                
            }else {
                imageView.isHidden = true
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func addGestureRecognizer(){
        gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    func viewImage(){
        if let image = imageView.image{
            UserStore.shared.selectedImage = image
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageNavController")
            present(viewController, animated: true, completion: nil)
        }
    }
    fileprivate func showPicker(_ type: UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = type
        present(imagePicker, animated: true, completion: nil)
        
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
    
    
    //MARK: - IBACtions
    
    @IBAction func choosePhoto(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Picture", message: "Choose a Picture type", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action) in self.showPicker(.camera)}))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action) in self.showPicker(.photoLibrary)}))
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func saveUser(_ sender: AnyObject) {
        
        guard let fullName = fullNameText.text, fullName != "" else {
            //show error
            let alert = Utils.createAlert("ERROR", message: "Please provide a Full Name", dismissButtonTitle: "Close")
            present(alert, animated: true, completion: nil)
            //need return or it just keeps on going on
            return
        }
        let avatarImage = Utils.imageToString(image: imageView.image)
        print("Avatar Size: \(avatarImage?.characters.count)")
        //create userModel
        let user = User(fullName: fullName, avatarBase64: avatarImage)
        
        
        //call webservices
        
        WebServices.shared.postObject(user) { (object, error) in
            if error == nil{
                //hit save button and updating the user shared model--placing the info back where it was
                UserStore.shared.user?.fullName = fullName
                UserStore.shared.user?.avatarBase64 = avatarImage
                let alert = Utils.createAlert("WONDERFUL", message: "You have an Image", dismissButtonTitle: "Close")
                self.present(alert, animated: true, completion: nil)
                
            }else{
                let alert = Utils.createAlert("ERROR", message: "Something went wrong", dismissButtonTitle: "Close")
                self.present(alert, animated: true, completion: nil)
                
            }
            
            
        }
        
        
        
        //show save message
        
    }
    
}
extension UserProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    //implemented for us--no code--just include it--gives us the right to make functions to pull up picture or take camera pic
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            //take original image and scale it down 512 x 512 pixels
            let maxSize: CGFloat = 128
            let scale = maxSize / image.size.width
            let newHeight = image.size.height * scale
            
            UIGraphicsBeginImageContext(CGSize(width: maxSize, height:newHeight))
            image.draw(in: CGRect(x: 0, y: 0, width:maxSize, height:newHeight))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            imageView.image = resizedImage
            
            imageView.isHidden = false
            if gestureRecognizer != nil {
                imageView.removeGestureRecognizer(gestureRecognizer)
            }
            addGestureRecognizer()
        }
    }
}

