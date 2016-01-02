//
//  GalleryViewController.swift
//  Social Photos
//
//  Created by shoulong li on 12/27/15.
//  Copyright © 2015 shoulong li. All rights reserved.
//

import UIKit
import Photos

private let AllPhotosReuseIdentifier = "AllPhotosCell"
private let CollectionCellReuseIdentifier = "CollectionCell"
private let AllPhotosSegue = "showAllPhotos"
private let CollectionSegue = "showCollection"

class GalleryViewController: UITableViewController , PHPhotoLibraryChangeObserver {

    var sectionFetchResults: [PHFetchResult] = []
    var sectionLocalizedTitles: [String] = []
    override func awakeFromNib() {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let allPhotos = PHAsset.fetchAssetsWithOptions(allPhotosOptions)
        
        let smartAlbums = PHAssetCollection.fetchAssetCollectionsWithType(.SmartAlbum, subtype: .AlbumRegular, options: nil)
        
        let topLevelUserCollections = PHCollectionList.fetchTopLevelUserCollectionsWithOptions(nil)
        
        self.sectionFetchResults = [allPhotos, smartAlbums, topLevelUserCollections]
        self.sectionLocalizedTitles = ["", NSLocalizedString("Smart Albums", comment: ""), NSLocalizedString("Albums", comment: "")]
        PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)
    }
    
    deinit {
        PHPhotoLibrary.sharedPhotoLibrary().unregisterChangeObserver(self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
                
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionFetchResults.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        } else {
            let fetchResults = self.sectionFetchResults[section]
            return fetchResults.count
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
   
        let cell: UITableViewCell = UITableViewCell()

        if indexPath.section == 0 {
//            cell = tableView.dequeueReusableCellWithIdentifier(AllPhotosReuseIdentifier, forIndexPath: indexPath)
            cell.textLabel!.text = NSLocalizedString("All Photos", comment: "")
        } else {
            let fetchResult = self.sectionFetchResults[indexPath.section]
            let collection = fetchResult[indexPath.row] as! PHCollection
            
//            cell = tableView.dequeueReusableCellWithIdentifier(CollectionCellReuseIdentifier, forIndexPath: indexPath)
            cell.textLabel!.text = collection.localizedTitle
        }
        
        return cell
    }
    
    //MARK: - PHPhotoLibraryChangeObserver
    
    func photoLibraryDidChange(changeInstance: PHChange) {
        /*
        Change notifications may be made on a background queue. Re-dispatch to the
        main queue before acting on the change as we'll be updating the UI.
        */
        dispatch_async(dispatch_get_main_queue()) {
            // Loop through the section fetch results, replacing any fetch results that have been updated.
            var updatedSectionFetchResults = self.sectionFetchResults
            var reloadRequired = false
            
            self.sectionFetchResults.enumerate().forEach{index, collectionsFetchResult in
                if let changeDetails = changeInstance.changeDetailsForFetchResult(collectionsFetchResult) {
                    
                    updatedSectionFetchResults[index] = changeDetails.fetchResultAfterChanges
                    reloadRequired = true
                }
            }
            
            if reloadRequired {
                self.sectionFetchResults = updatedSectionFetchResults
                self.tableView.reloadData()
            }
            
        }
    }

    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionLocalizedTitles[section]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("tableView")
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if indexPath.section == 0 {
            performSegueWithIdentifier(AllPhotosSegue, sender: cell)
        } else {
            performSegueWithIdentifier(CollectionSegue, sender: cell)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        print("prepareForSegure : \(segue.identifier)")
        if let assetsGridViewController = segue.destinationViewController as? AssetsGridViewController {
            
            if let cell = sender as? UITableViewCell {
                assetsGridViewController.title = cell.textLabel?.text
                if segue.identifier == AllPhotosSegue || segue.identifier == CollectionSegue {
                    
                    // Get the PHFetchResult for the selected section.
                    let indexPath = self.tableView.indexPathForCell(cell)!
                    let fetchResult = self.sectionFetchResults[indexPath.section]
                    
                    if segue.identifier == AllPhotosSegue {
                        assetsGridViewController.assetsFetchResults = fetchResult
                    } else if segue.identifier == CollectionSegue {
                        // Get the PHAssetCollection for the selected row.
                        guard let assetCollection = fetchResult[indexPath.row] as? PHAssetCollection else {
                            return
                        }
                        
                        // Configure the AAPLAssetGridViewController with the asset collection.
                        let assetsFetchResult = PHAsset.fetchAssetsInAssetCollection(assetCollection, options: nil)
                        
                        assetsGridViewController.assetsFetchResults = assetsFetchResult
                        assetsGridViewController.assetCollection = assetCollection
                    }

                }
            }
            
            
        }
    }


}
