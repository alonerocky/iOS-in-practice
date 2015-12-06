//
//  CountryDetailViewController.swift
//  RemoteTableView
//
//  Created by shoulong li on 12/5/15.
//  Copyright © 2015 Shoulong Li. All rights reserved.
//

import UIKit

class CountryDetailViewController: UIViewController {
    
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var countryCodeLabel: UILabel!
    
    var country: Country?
    init(country: Country?, nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.country = country
        navigationItem.title = country?.countryName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        countryNameLabel?.text = country?.countryName
        countryCodeLabel?.text = country?.countryCode
    }
    
}
