//
//  PrayerSettingsViewController.swift
//  PrayerList
//
//  Created by Devin  on 29/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import UIKit

enum PrayerSettingsTableItem {
    case name
    case delete
    
    static var sections: [[PrayerSettingsTableItem]] {
        return [[.name],[.delete]]
    }
}

class PrayerSettingsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var prayer: PrayerModel!
    weak var delegate: PrayerSettingsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: PrayerSettingsTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: PrayerSettingsTableViewCell.reuseIdentifier)
        tableView.estimatedRowHeight = 44
        self.title = "Settings"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.backgroundColor = Theme.Color.Background
        tableView.reloadData()
    }
    
    @IBAction func doneAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func deletePrayer(){
        let alert = UIAlertController(title: "Delete Prayer", message: "Are you sure you want to delete this prayer?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (deleteAction) in
            self.delete()
        }))
        
        alert.view.tintColor = Theme.Color.PrimaryTint
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func delete(){
        PrayerInterface.deletePrayer(prayerModel: self.prayer, inContext: CoreDataManager.mainContext)
        self.dismiss(animated: true, completion: nil)
        self.delegate?.prayerDeleted()
    }
    
}

extension PrayerSettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return PrayerSettingsTableItem.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PrayerSettingsTableItem.sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = PrayerSettingsTableItem.sections[indexPath.section][indexPath.row]
        
        switch item {
        case .name:
            let cell = tableView.dequeueReusableCell(withIdentifier: PrayerSettingsTableViewCell.reuseIdentifier, for: indexPath) as! PrayerSettingsTableViewCell
            cell.setUp(title: "Name", detail: prayer.name, isEditable: true, item: item)
            cell.delegate = self
            return cell
            
        case .delete:
            let cell = tableView.dequeueReusableCell(withIdentifier: PrayerSettingsTableViewCell.reuseIdentifier, for: indexPath) as! PrayerSettingsTableViewCell
            cell.setUp(title: "Delete", detail: nil, isEditable: false, item: item)
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = PrayerSettingsTableItem.sections[indexPath.section][indexPath.row]
        
        switch item {
        case .name:
            print("Name Selected")
        case .delete:
            deletePrayer()
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Details"
        } else {
            return nil
        }
    }
}

extension PrayerSettingsViewController: CellTextDelegate {
    func textChanged(text: String?, item: PrayerSettingsTableItem) {
        switch item {
        case .name:
            if let text = text {
                self.prayer.name = text
                PrayerInterface.savePrayer(prayer: prayer, inContext: CoreDataManager.mainContext)
                self.view.endEditing(true)
            }
        case .delete:
            print("delete")
        }
    }
}
