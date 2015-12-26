//
//  PhotoLibraryViewController.swift
//  Social Photos
//
//  Created by shoulong li on 12/23/15.
//  Copyright © 2015 shoulong li. All rights reserved.
//

import UIKit

class PhotoLibraryViewController: UIImagePickerController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.allowsEditing = false
        self.sourceType = .PhotoLibrary
        self.delegate = self
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.    
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
