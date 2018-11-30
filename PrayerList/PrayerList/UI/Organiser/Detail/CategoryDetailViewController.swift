//
//  CategoryDetailViewController.swift
//  PrayerList
//
//  Created by Devin  on 30/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import UIKit

class CategoryDetailViewController: BaseViewController {
    
    var category: PrayerCategoryModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = category.name
        // Do any additional setup after loading the view.
    }

}
