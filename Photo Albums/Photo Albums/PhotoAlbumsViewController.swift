//
//  PhotoAlbumsViewController.swift
//  Photo Albums
//
//  Created by shoulong li on 12/7/15.
//  Copyright © 2015 shoulong li. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import FBSDKShareKit

class PhotoAlbumsViewController: UIViewController {
    
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        let loginPage = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        
        let loginPageNav = UINavigationController(rootViewController: loginPage)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.window!.rootViewController = loginPageNav
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        fetchAlbum()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchAlbum(){
        
        let request =  FBSDKGraphRequest(graphPath: "me/albums", parameters: nil)
        
        //        let handler = FBSDKGraphRequestHandler()
        //(FBSDKGraphRequestConnection!, AnyObject!, NSError!) -> Void
        
        request.startWithCompletionHandler({
            (connection: FBSDKGraphRequestConnection!, result: AnyObject!, error: NSError!) in
            
            if error != nil {
                print(error.localizedDescription)
            } else {
                print("\(result)")
            }
        });
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
