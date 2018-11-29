//
//  PrayerModelSettingsController.swift
//  PrayerList
//
//  Created by Devin  on 29/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import UIKit

class PrayerModelSettingsController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var prayer: PrayerModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = prayer.name
        
        tableView.register(UINib(nibName: PrayerSettingsTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: PrayerSettingsTableViewCell.reuseIdentifier)
    }

}

extension PrayerModelSettingsController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PrayerSettingsTableViewCell.reuseIdentifier, for: indexPath) as! PrayerSettingsTableViewCell
        
        cell.setUp(title: "thing")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Prayers"
    }
}



