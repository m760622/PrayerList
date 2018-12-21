//
//  BaseViewController.swift
//  PrayerList
//
//  Created by Devin  on 29/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    weak var plusVisibilityDelegate: TabPlusDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBar = self.tabBarController as? TabBarController {
            plusVisibilityDelegate = tabBar
        }
        
        self.view.backgroundColor = Theme.Color.Background
    }

}
