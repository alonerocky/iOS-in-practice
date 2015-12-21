//
//  AlbumCollectionViewController.swift
//  Social Photos
//
//  Created by shoulong li on 12/18/15.
//  Copyright © 2015 shoulong li. All rights reserved.
//

import UIKit
private let reuseIdentifier: String = "photoReuseIdentifier"
private let sectionInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)

class AlbumCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var graphApi: GraphApi = GraphApi()
    var album: Album?
    var photos: [Photo] = []
    var photoCache = ImageCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        if let currentAlbum = album {
            if let albumId = currentAlbum.id {
                graphApi.fetchPhotos(albumId, handler: photosHandler)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func photosHandler(photos: [Photo]) {
        self.photos = photos
        print("\(self.photos.count)")
        dispatch_async(dispatch_get_main_queue(), {
            self.collectionView?.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return photos.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! AlbumPhotoViewCell
        
        // Configure the cell
        cell.backgroundColor = UIColor.greenColor()
        let photo = photos[indexPath.row]
        
        if let photoUrl = photo.picture {
            if let image = photoCache.get(photoUrl) {
                cell.imageView.image = image
            } else {
                let imgURL: NSURL = NSURL(string: photoUrl)!
                let request: NSURLRequest = NSURLRequest(URL: imgURL)
                let session = NSURLSession.sharedSession()
                let dataTask = session.dataTaskWithRequest(request, completionHandler: {
                    (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                    if error == nil {
                        let image = UIImage(data: data!)
                        self.photoCache.put(photoUrl, image: image!)
                        dispatch_async(dispatch_get_main_queue(), {
                            if let cellToUpdate = collectionView.cellForItemAtIndexPath(indexPath) as? AlbumPhotoViewCell  {
                                
                                cellToUpdate.imageView.image = image!
                            }
                        })
                    }
                })
                dataTask.resume()
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
        let frameSize: CGFloat = collectionView.frame.size.width / 3.0 - 4.0
        return CGSize(width: frameSize, height: frameSize)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    
}
