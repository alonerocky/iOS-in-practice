//
//  SettingsViewController.swift
//  Social Photos
//
//  Created by shoulong li on 12/14/15.
//  Copyright © 2015 shoulong li. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class SettingsViewController: UIViewController {
    
    var graphApi: GraphApi = GraphApi()
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    @IBAction func logoutTapped(sender: AnyObject) {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        let loginPage = self.storyboard?.instantiateViewControllerWithIdentifier("FBLoginViewController") as! FBLoginViewController
        let loginPageNav = UINavigationController(rootViewController: loginPage)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.window!.rootViewController = loginPageNav
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        graphApi.fetchMeProfilePicture(loadProfilePicture)
    }
    
    func loadProfilePicture(pictureUrl: String) {
        let imageDownloader = ImageDownloader()
        imageDownloader.loadImage(pictureUrl, completeHandler: {(image: UIImage) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                self.profilePictureImageView.image = image
            })
            }, errorHandler: nil)
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
