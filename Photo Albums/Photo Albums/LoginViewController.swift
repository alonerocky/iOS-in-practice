//
//  ViewController.swift
//  Photo Albums
//
//  Created by shoulong li on 12/7/15.
//  Copyright © 2015 shoulong li. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var loginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        loginButton.delegate = self
        loginButton.readPermissions = ["public_profile", "email", "user_photos"]
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if FBSDKAccessToken.currentAccessToken() != nil {
            launchToPhotoAlbums()
        }

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
                launchToPhotoAlbums()
            }
        }
    }
    
    func launchToPhotoAlbums() {
        let photosAlbumsPage = self.storyboard?.instantiateViewControllerWithIdentifier("PhotoAlbumsViewController") as! PhotoAlbumsViewController
        
        let photosAlbumsPageNav = UINavigationController(rootViewController: photosAlbumsPage)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.window!.rootViewController = photosAlbumsPageNav

    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("user is logged out")
    }


}

