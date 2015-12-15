//
//  FBLoginViewController.swift
//  Social Photos
//
//  Created by shoulong li on 12/14/15.
//  Copyright © 2015 shoulong li. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class FBLoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var loginButton: FBSDKLoginButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loginButton.delegate = self
        loginButton.readPermissions = ["public_profile", "email", "user_photos", "user_videos"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error != nil {
            print(error.localizedDescription)
        } else if result.isCancelled {
            // Handle cancellations
        } else {
            print("permissions: \(result.grantedPermissions)")
            if result.grantedPermissions.contains("user_photos") {
                
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("user is logged out")
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
