//
//  AssetsGridViewController.swift
//  Social Photos
//
//  Created by shoulong li on 12/28/15.
//  Copyright © 2015 shoulong li. All rights reserved.
//

import UIKit
import PhotosUI
import Photos

private let reuseIdentifier = "assetReuseIdentifier"

class AssetsGridViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, PHPhotoLibraryChangeObserver {
    
    var assetsFetchResults: PHFetchResult?
    var assetCollection: PHAssetCollection?
    
    let LINE_SPACING: CGFloat = 2.0
    let INTERITEM_SPACING: CGFloat = 2.0
    let COLUMNS: CGFloat = 4.0
    
    private var imageManager: PHCachingImageManager?
    private var previousPreheatRect: CGRect = CGRect()
    
    
    static var AssetGridThumbnailSize: CGSize = CGSize()
    
    override func awakeFromNib() {
        self.imageManager = PHCachingImageManager()
        self.resetCachedAssets()
        
        PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)
    }
    
    deinit {
        PHPhotoLibrary.sharedPhotoLibrary().unregisterChangeObserver(self)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.backgroundColor = UIColor.whiteColor()
        //self.collectionView!.registerClass(GridViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Begin caching assets in and around collection view's visible rect.
        self.updateCachedAssets()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Determine the size of the thumbnails to request from the PHCachingImageManager
        let scale = UIScreen.mainScreen().scale
        //let cellSize = (self.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
        let itemWidth = getCollectionCellSize()
        let cellSize = CGSize(width: itemWidth, height: itemWidth)
        AssetsGridViewController.AssetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale)
        
//        // Add button to the navigation bar if the asset collection supports adding content.
//        if self.assetCollection == nil || self.assetCollection!.canPerformEditOperation(.AddContent) {
//            self.navigationItem.rightBarButtonItem = self.addButton
//        } else {
//            self.navigationItem.rightBarButtonItem = nil
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - PHPhotoLibraryChangeObserver
    
    func photoLibraryDidChange(changeInstance: PHChange) {
        // Check if there are changes to the assets we are showing.
        guard let
            assetsFetchResults = self.assetsFetchResults,
            collectionChanges = changeInstance.changeDetailsForFetchResult(assetsFetchResults)
            else {return}
        
        /*
        Change notifications may be made on a background queue. Re-dispatch to the
        main queue before acting on the change as we'll be updating the UI.
        */
        dispatch_async(dispatch_get_main_queue()) {
            // Get the new fetch result.
            self.assetsFetchResults = collectionChanges.fetchResultAfterChanges
            
            let collectionView = self.collectionView!
            
            if !collectionChanges.hasIncrementalChanges || collectionChanges.hasMoves {
                // Reload the collection view if the incremental diffs are not available
                collectionView.reloadData()
                
            } else {
                /*
                Tell the collection view to animate insertions and deletions if we
                have incremental diffs.
                */
                collectionView.performBatchUpdates({
                    if let removedIndexes = collectionChanges.removedIndexes
                        where removedIndexes.count > 0 {
                            collectionView.deleteItemsAtIndexPaths(removedIndexes.aapl_indexPathsFromIndexesWithSection(0))
                    }
                    
                    if let insertedIndexes = collectionChanges.insertedIndexes
                        where insertedIndexes.count > 0 {
                            collectionView.insertItemsAtIndexPaths(insertedIndexes.aapl_indexPathsFromIndexesWithSection(0))
                    }
                    
                    if let changedIndexes = collectionChanges.changedIndexes
                        where changedIndexes.count > 0 {
                            collectionView.reloadItemsAtIndexPaths(changedIndexes.aapl_indexPathsFromIndexesWithSection(0))
                    }
                    }, completion:  nil)
            }
            
            self.resetCachedAssets()
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.assetsFetchResults?.count ?? 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let asset = self.assetsFetchResults![indexPath.item] as! PHAsset
        
        // Dequeue an AAPLGridViewCell.
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! GridViewCell
        cell.representedAssetIdentifier = asset.localIdentifier
        
        // Add a badge to the cell if the PHAsset represents a Live Photo.
        if #available(iOS 9.1, *) {
            let hasLivePhoto = asset.mediaSubtypes.contains(.PhotoLive)
            if hasLivePhoto {
                // Add Badge Image to the cell to denote that the asset is a Live Photo.
                let badge = PHLivePhotoView.livePhotoBadgeImageWithOptions(.OverContent)
                cell.livePhotoBadgeImage = badge
            }
        }
        
        // Request an image for the asset from the PHCachingImageManager.
        self.imageManager?.requestImageForAsset(asset,
            targetSize: AssetsGridViewController.AssetGridThumbnailSize,
            contentMode: PHImageContentMode.AspectFill,
            options: nil)
            {result, info in
                // Set the cell's thumbnail image if it's still showing the same asset.
                if cell.representedAssetIdentifier == asset.localIdentifier {
                    cell.thumbnailImage = result
                }
        }
        
        return cell

    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    //MARK: UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let itemWidth = getCollectionCellSize()
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return LINE_SPACING
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return INTERITEM_SPACING
    }

    
    //MARK: - UIScrollViewDelegate
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        // Update cached assets for the new visible area.
        self.updateCachedAssets()
    }
    
    //MARK: - Asset Caching
    
    private func resetCachedAssets() {
        self.imageManager?.stopCachingImagesForAllAssets()
        self.previousPreheatRect = CGRectZero
    }
    
    private func updateCachedAssets() {
        guard self.isViewLoaded() && self.view.window != nil else {
            return
        }
        
        // The preheat window is twice the height of the visible rect.
        var preheatRect = self.collectionView!.bounds
        preheatRect = CGRectInset(preheatRect, 0.0, -0.5 * CGRectGetHeight(preheatRect))
        
        /*
        Check if the collection view is showing an area that is significantly
        different to the last preheated area.
        */
        let delta = abs(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.previousPreheatRect))
        if delta > CGRectGetHeight(self.collectionView!.bounds) / 3.0 {
            
            // Compute the assets to start caching and to stop caching.
            var addedIndexPaths: [NSIndexPath] = []
            var removedIndexPaths: [NSIndexPath] = []
            
            self.computeDifferenceBetweenRect(self.previousPreheatRect, andRect: preheatRect, removedHandler: {removedRect in
                let indexPaths = self.collectionView!.aapl_indexPathsForElementsInRect(removedRect)
                removedIndexPaths += indexPaths
                }, addedHandler: {addedRect in
                    let indexPaths = self.collectionView!.aapl_indexPathsForElementsInRect(addedRect)
                    addedIndexPaths += indexPaths
            })
            
            let assetsToStartCaching = self.assetsAtIndexPaths(addedIndexPaths)
            let assetsToStopCaching = self.assetsAtIndexPaths(removedIndexPaths)
            
            // Update the assets the PHCachingImageManager is caching.
            self.imageManager?.startCachingImagesForAssets(assetsToStartCaching,
                targetSize: AssetsGridViewController.AssetGridThumbnailSize,
                contentMode: PHImageContentMode.AspectFill,
                options: nil)
            self.imageManager?.stopCachingImagesForAssets(assetsToStopCaching,
                targetSize: AssetsGridViewController.AssetGridThumbnailSize,
                contentMode: PHImageContentMode.AspectFill,
                options: nil)
            
            // Store the preheat rect to compare against in the future.
            self.previousPreheatRect = preheatRect
        }
    }
    
    private func computeDifferenceBetweenRect(oldRect: CGRect, andRect newRect: CGRect, removedHandler: (CGRect)->Void, addedHandler: (CGRect)->Void) {
        if CGRectIntersectsRect(newRect, oldRect) {
            let oldMaxY = CGRectGetMaxY(oldRect)
            let oldMinY = CGRectGetMinY(oldRect)
            let newMaxY = CGRectGetMaxY(newRect)
            let newMinY = CGRectGetMinY(newRect)
            
            if newMaxY > oldMaxY {
                let rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY))
                addedHandler(rectToAdd)
            }
            
            if oldMinY > newMinY {
                let rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY))
                addedHandler(rectToAdd)
            }
            
            if newMaxY < oldMaxY {
                let rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY))
                removedHandler(rectToRemove)
            }
            
            if oldMinY < newMinY {
                let rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY))
                removedHandler(rectToRemove)
            }
        } else {
            addedHandler(newRect)
            removedHandler(oldRect)
        }
    }
    
    private func assetsAtIndexPaths(indexPaths: [NSIndexPath]) -> [PHAsset] {
        
        let assets = indexPaths.map{self.assetsFetchResults![$0.item] as! PHAsset}
        
        return assets
    }
    
    func getCollectionCellSize() -> CGFloat {
        return (view.bounds.size.width - ( COLUMNS - 1 ) * INTERITEM_SPACING) / COLUMNS
    }

}
