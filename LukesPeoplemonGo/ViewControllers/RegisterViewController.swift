//
//  RegisterViewController.swift
//  LukesPeoplemonGo
//
//  Created by Lucas Lell on 11/8/16.
//  Copyright © 2016 Luuke192. All rights reserved.
//

import UIKit
// Step 9: import MBProgressHUD
import MBProgressHUD

// Step 8: Create VC with IBOutlets and IBActions
class RegisterViewController: UIViewController {
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerTapped(_ sender: AnyObject) {
        
        //validate user input
        guard let fullName = fullNameTextField.text, fullName != "" else {
            //show error
            let alert = Utils.createAlert("Login Error", message: "Please provide a UserName", dismissButtonTitle: "Close")
            present(alert, animated: true, completion: nil)
            //need return or it just keeps on going on
            return
        }
        guard let email = emailTextField.text, email != "" && Utils.isValidEmail(email)
            else {
                present(Utils.createAlert("Login Error", message: "Please provide a valid Email address"), animated: true, completion: nil)
                return
        }
        guard let password = passwordTextField.text, password != ""
            else {
                present(Utils.createAlert("Login Error", message: "Please provide a valid Password"), animated: true, completion: nil)
                return
        }
        guard let confirm = confirmTextField.text, password == confirm
            else {
                present(Utils.createAlert("Login Error", message: "Passwords do not Match"), animated: true, completion: nil)
                return
                
        }
        
        
        //Going to go ahead with the register save
        
        //show something on screen that shows what we are doing-- HUD--heads up display
        MBProgressHUD.showAdded(to: view, animated: true)    //this is the spinny wheel
        
        
        let user = User(fullName: fullName, password: password, email: email, avatarBase64: "placeholder", apiKey: Constants.apiKey)//register
        
        UserStore.shared.register(user) { (success, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            
            
            //if success going back to main
            if success{
                self.dismiss(animated: true, completion: nil)
                
            }else if let error = error {
                self.present(Utils.createAlert(message: error), animated: true, completion: nil)
                
            }else{
                self.present(Utils.createAlert(message: Constants.JSON.unknownError), animated: true, completion: nil)
            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
