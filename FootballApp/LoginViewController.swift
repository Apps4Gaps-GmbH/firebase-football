//
//  LoginViewController.swift
//  FootballApp
//
//  Created by Tomer Ciucran on 2/3/16.
//  Copyright © 2016 Apps4Gaps. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import MBProgressHUD

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let fbLoginButton = FBSDKLoginButton()
        fbLoginButton.center = CGPoint(x: self.view.center.x, y: self.view.bounds.height - fbLoginButton.bounds.height - 50)
        fbLoginButton.readPermissions = ["email"]
        fbLoginButton.delegate = self
        self.view.addSubview(fbLoginButton)
    }
    
    // MARK: - FBSDKLoginButtonDelegate
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        let ref = Firebase(url: "https://resplendent-torch-3135.firebaseio.com")
        
        if error != nil {
            print("Facebook login failed. Error \(error)")
        } else if result.isCancelled {
            print("Facebook login was cancelled.")
        } else {
            let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
            ref.authWithOAuthProvider("facebook", token: accessToken,
                withCompletionBlock: { error, authData in
                    if error != nil {
                        print("Login failed. \(error)")
                    } else {
                        print("Logged in! \(authData)")
                        AppDelegate.sharedDelegate().setMainAsRootViewController()
                    }
            })
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    
    // MARK: - User Interaction

    @IBAction func loginButtonTapped(sender: AnyObject) {
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.mode = .Indeterminate
            hud.labelText = "Loading"
            
            let ref = Firebase(url: "https://resplendent-torch-3135.firebaseio.com/users")
            
            ref.authUser(emailTextField.text, password: passwordTextField.text, withCompletionBlock: { (error, authData) -> Void in
                hud.hide(true)
                
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: "Invalid credentials", preferredStyle: UIAlertControllerStyle.Alert)
                    let destroyAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive, handler: { (action) -> Void in })
                    alert.addAction(destroyAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
//                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "loggedIn")
                    NSUserDefaults.standardUserDefaults().setObject(authData.uid, forKey: "uid")
                    
                    let alert = UIAlertController(title: "Success", message: "Successful login", preferredStyle: UIAlertControllerStyle.Alert)
                    let destroyAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive, handler: { (action) -> Void in })
                    alert.addAction(destroyAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    let userRef = Firebase(url: "https://resplendent-torch-3135.firebaseio.com/users/\(authData.uid)")
                    
                    userRef.observeEventType(.Value, withBlock: { (snapshot) -> Void in
//                        if snapshot.value.objectForKey("favourite_team") as! String != "" {
//                            // to team list
//                        } else {
//                            // to team selection
//                        }
                        
                        print(snapshot.value.objectForKey("favourite_team") as! String)
                    })
                }
            })
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
