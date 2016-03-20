//
//  MainViewController.swift
//  flickrParty
//
//  Created by gunesmert on 20/03/16.
//  Copyright © 2016 Mert Ahmet Güneş. All rights reserved.
//

import UIKit
import PureLayout

class MainViewController : BaseTableViewController {
    private var feedElements: [FeedElement]? = []
    
    private var pageNumber: NSNumber! = 1
    
    // MARK: - Constructors
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    override init() {
        super.init()
        
        commonInit()
    }
    
    func commonInit() {
        
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        loadData(withRefresh: true)
    }
    
    // MARK: - Interface
    
    override func shouldShowLogoAsTitleView() -> Bool {
        return true
    }
    
    // MARK: - Data
    
    override func loadData(withRefresh refresh: Bool) -> Bool {
        if !super.loadData(withRefresh: refresh) {
            return false
        }
        
        if refresh == true {
            pageNumber = 1
        } else {
            pageNumber = NSNumber(integer: pageNumber.integerValue + 1)
        }
        
        NetworkClient.sharedClient.getFeedElements(withPageNumber: pageNumber, withTags: ["party"]) { (pageNumber, elements, error) -> Void in
            if error == nil {
                if refresh == true {
                    self.feedElements = elements
                } else {
                    for element in elements! {
                        self.feedElements?.append(element)
                    }
                }
            } else {
                
            }
        }
        
        return true
    }
}
