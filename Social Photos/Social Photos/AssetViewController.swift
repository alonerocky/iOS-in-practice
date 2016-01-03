//
//  AssetViewController.swift
//  Social Photos
//
//  Created by shoulong li on 1/2/16.
//  Copyright © 2016 shoulong li. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class AssetViewController: UIViewController, PHPhotoLibraryChangeObserver {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var progressView: UIProgressView!
    
    
    var asset: PHAsset?
    var assetCollection: PHAssetCollection?
    
    
    private var playerLayer: AVPlayerLayer?
    private var lastTargetSize: CGSize = CGSize()
    private var playingHint: Bool = false
    
    deinit {
        PHPhotoLibrary.sharedPhotoLibrary().unregisterChangeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set the appropriate toolbarItems based on the mediaType of the asset.
//        if self.asset?.mediaType == PHAssetMediaType.Video {
//            self.showPlaybackToolbar()
//        } else {
//            self.showStaticToolbar()
//        }
        
        // Enable the edit button if the asset can be edited.
        let isEditable = (self.asset?.canPerformEditOperation(.Properties) ?? false) || (self.asset?.canPerformEditOperation(.Content) ?? true)
        //self.editButton.enabled = isEditable
        
        // Enable the trash button if the asset can be deleted.
        var isTrashable = false
        if let assetCollection = self.assetCollection {
            isTrashable = assetCollection.canPerformEditOperation(.RemoveContent)
        } else {
            isTrashable = self.asset?.canPerformEditOperation(.Delete) ?? false
        }
        //self.trashButton.enabled = isTrashable
        
        self.updateImage()
        
        self.view.layoutIfNeeded()
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
    
    
    //MARK: - PHPhotoLibraryChangeObserver
    
    func photoLibraryDidChange(changeInstance: PHChange) {
        // Call might come on any background queue. Re-dispatch to the main queue to handle it.
        dispatch_async(dispatch_get_main_queue()) {
            // Check if there are changes to the asset we're displaying.
            guard let
                asset = self.asset,
                changeDetails = changeInstance.changeDetailsForObject(asset) else {
                    return
            }
            
            // Get the updated asset.
            self.asset = changeDetails.objectAfterChanges as? PHAsset
            
            // If the asset's content changed, update the image and stop any video playback.
            if changeDetails.assetContentChanged {
                self.updateImage()
                
                self.playerLayer?.removeFromSuperlayer()
                self.playerLayer = nil
            }
        }
    }
    
    private var targetSize: CGSize {
        let scale = UIScreen.mainScreen().scale
        let targetSize = CGSizeMake(CGRectGetWidth(self.imageView.bounds) * scale, CGRectGetHeight(self.imageView.bounds) * scale)
        return targetSize
    }
    
    private func updateImage() {
        self.lastTargetSize = self.targetSize
        
        self.updateStaticImage()
    }
    
    private func updateStaticImage() {
        // Prepare the options to pass when fetching the live photo.
        let options = PHImageRequestOptions()
        options.deliveryMode = .HighQualityFormat
        options.networkAccessAllowed = true
        options.progressHandler = {progress, error, stop, info in
            /*
            Progress callbacks may not be on the main thread. Since we're updating
            the UI, dispatch to the main queue.
            */
            dispatch_async(dispatch_get_main_queue()) {
                self.progressView.progress = Float(progress)
            }
        }
        
        PHImageManager.defaultManager().requestImageForAsset(self.asset!, targetSize: self.targetSize, contentMode: .AspectFit, options: options) {result, info in
            // Hide the progress view now the request has completed.
            self.progressView.hidden = true
            
            // Check if the request was successful.
            if result == nil {
                return
            }
            
            // Show the UIImageView and use it to display the requested image.
            self.showStaticPhotoView()
            self.imageView.image = result
        }
    }
    
    private func showStaticPhotoView() {
        self.imageView.hidden = false
    }



}
