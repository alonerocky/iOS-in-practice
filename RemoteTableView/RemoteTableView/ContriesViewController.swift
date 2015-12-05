//
//  ContriesViewController.swift
//  RemoteTableView
//
//  Created by Shoulong Li on 12/3/15.
//  Copyright (c) 2015 Shoulong Li. All rights reserved.
//

import UIKit

class ContriesViewController: UITableViewController {
    
    let url: String = "http://www.kaleidosblog.com/tutorial/tutorial.json"
    var countryList: [Country] = []
    var api: RemoteApi = RemoteApi()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "countryItemCell")
        api.fetchData(url, completeHandler: completeHandler, errorHandler: nil)
    }
    
    func completeHandler(data: NSData?) {
        do {
            if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSArray {
                for var i = 0; i < json.count; i++ {
                    let country = json[i] as! NSDictionary
                    if country["code"] != nil && country["country"] != nil {
                        let oneCountry = Country(countryName: country["country"] as! String, countryCode: country["code"] as! String)
                        countryList.append(oneCountry)
                    }
                }
                refresh()
            }
        } catch {
        }
    }
    
    func refresh() {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
    
    
    func errorHandler(error: NSError) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return countryList.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("countryItemCell", forIndexPath: indexPath) as UITableViewCell;
        
        cell.textLabel?.text = countryList[indexPath.row].countryName
        cell.detailTextLabel?.text = countryList[indexPath.row].countryCode
        // Configure the cell...
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = countryList[indexPath.row]
        
        let detailVc = CountryDetailViewController(country: item, nibName: "CountryDetailViewController", bundle: nil)
        showViewController(detailVc, sender: self)
        //showDetailViewController(<#T##vc: UIViewController##UIViewController#>, sender: <#T##AnyObject?#>)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
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
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
