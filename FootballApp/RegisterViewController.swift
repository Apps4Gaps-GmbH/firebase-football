//
//  RegisterViewController.swift
//  FootballApp
//
//  Created by Tomer Ciucran on 2/3/16.
//  Copyright © 2016 Apps4Gaps. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, UITextFieldDelegate {

    var user: User!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpTapped(sender: AnyObject) {
        if emailTextField.text != "" && passwordTextField.text != "" && confirmTextField.text != "" && passwordTextField.text == confirmTextField.text {
            let ref = Firebase(url: "https://resplendent-torch-3135.firebaseio.com")
            ref.createUser(emailTextField.text, password: passwordTextField.text,
                withValueCompletionBlock: { error, result in
                    if error != nil {
                        // There was an error creating the account
                    } else {
                        let uid = result["uid"] as? String
                        print("Successfully created user account with uid: \(uid)")
                        
                        ref.authUser(self.emailTextField.text, password: self.passwordTextField.text,
                            withCompletionBlock: { error, authData in
                                if error != nil {
                                    // There was an error logging in to this account
                                } else {
                                    // We are now logged in
                                    self.user = User(email: authData.providerData["email"] as! String, favouriteCountry: "")
                                    let usersRef = ref.childByAppendingPath("users/\(authData.uid)")
                                    usersRef.setValue(self.user.toAnyObject())
                                    
                                    let alert = UIAlertController(title: "Success", message: "Successfully registered user", preferredStyle: UIAlertControllerStyle.Alert)
                                    self.presentViewController(alert, animated: true, completion: nil)
                                }
                        })
                    }
            })
        } else {
            let alert = UIAlertController(title: "Error", message: "Fill in the fields and/or check your passwords", preferredStyle: UIAlertControllerStyle.Alert)
            presentViewController(alert, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
