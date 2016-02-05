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
    
    let ref = Firebase(url: firebaseUrl)
    
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
                        
                        let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email"])
                        request.startWithCompletionHandler({ (connection, result, error) -> Void in
                            if error != nil {
                                print("Graph request failed. \(error)")
                            } else {
                                self.showPassAlert(result.valueForKey("email") as! String, completion: { () -> Void in
                                    AppDelegate.sharedDelegate().setMainAsRootViewController()
                                })
                            }
                        })
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
                
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: "Invalid credentials", preferredStyle: UIAlertControllerStyle.Alert)
                    let destroyAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive, handler: { (action) -> Void in })
                    alert.addAction(destroyAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "loggedIn")
                    NSUserDefaults.standardUserDefaults().setObject(authData.uid, forKey: "uid")
                    
                    let userRef = Firebase(url: "https://resplendent-torch-3135.firebaseio.com/users/\(authData.uid)")
                    userRef.observeEventType(.Value, withBlock: { (snapshot) -> Void in
                        hud.hide(true)
                        print("\(snapshot.value)")
                        let favouriteTeam = snapshot.value.objectForKey("favourite_team") as? String
                        print("\(favouriteTeam)")
                        if favouriteTeam != nil && favouriteTeam != "" {
                            AppDelegate.sharedDelegate().setTeamsAsRootViewController()
                        }
                        else {
                            AppDelegate.sharedDelegate().setMainAsRootViewController()
                        }
                    })
                }
            })
        }
    }
    
    func showPassAlert(email: String, completion: () -> Void) {
        let alert = UIAlertController(title: "Register",
            message: "Enter your password",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .Default) { [unowned self] _ in
            let passwordField = alert.textFields![0]
            guard passwordField.text?.isEmpty == false else { return }
            
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.mode = .Indeterminate
            hud.labelText = "Loading"
            
            self.ref.createUser(email, password: passwordField.text, withCompletionBlock: { error in
                if error == nil {
                    self.ref.authUser(email, password: passwordField.text, withCompletionBlock: { (error, authData) -> Void in
                        let user = User(email: authData.providerData["email"] as! String, favouriteCountry: "")
                        let usersRef = self.ref.childByAppendingPath("users/\(authData.uid)")
                        usersRef.setValue(user.toAnyObject())
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "loggedIn")
                        NSUserDefaults.standardUserDefaults().setObject(authData.uid, forKey: "uid")
                        
                        hud.hide(true)
                        completion()
                    })
                }
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Cancel) { (action: UIAlertAction!) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textPassword) -> Void in
            textPassword.secureTextEntry = true
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
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
