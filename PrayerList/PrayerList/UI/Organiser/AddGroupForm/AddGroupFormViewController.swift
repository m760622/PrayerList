//
//  AddGroupFormViewController.swift
//  PrayerList
//
//  Created by Devin  on 1/12/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import UIKit

enum GroupFormCell {
    case name
    case prayer
    
    static var sections: [[GroupFormCell]] {
        return [[.name],[.prayer]]
    }
}

class AddGroupFormViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var category: PrayerCategoryModel!
    var selectedPrayers = [PrayerModel]()
    var groupName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: TextFieldTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: TextFieldTableViewCell.reuseIdentifier)
        selectedPrayers = category.prayers
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func setUpGroup(){
        if let name = groupName {
            let newGroup = PrayerGroupModel(name: name, order: category.groups.count)
            category.groups.append(newGroup)
            CategoryInterface.saveCategory(category: category, inContext: CoreDataManager.mainContext)
            
            for prayer in selectedPrayers {
                prayer.groups.append(newGroup)
                PrayerInterface.savePrayer(prayer: prayer, inContext: CoreDataManager.mainContext)
            }
        }
    }
    
    func validateInput() -> Bool {
        if groupName != nil {
            return true
        }
        return false
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addAction(_ sender: Any) {
        if validateInput() {
            setUpGroup()
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? PrayerSelectionViewController {
            destVC.selectedPrayers = self.selectedPrayers
            destVC.delegate = self
        }
    }
}

extension AddGroupFormViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return GroupFormCell.sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GroupFormCell.sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.reuseIdentifier, for: indexPath) as! TextFieldTableViewCell
        cell.delegate = self
        let item = GroupFormCell.sections[indexPath.section][indexPath.row]
        switch item {
        
        case .name:
            cell.setUp(title: "Name", detail: self.groupName, placeholder: "Name", isEditable: true, indexPath: indexPath)
            cell.accessoryType = .none
        case .prayer:
            let detailText = selectedPrayers.count > 1 ? "\(selectedPrayers.count) Selected" : selectedPrayers.first?.name
            cell.setUp(title: "Prayers", detail: detailText, placeholder: "Select prayers", isEditable: false, indexPath: indexPath, detailColor: Theme.Color.Subtitle)
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = GroupFormCell.sections[indexPath.section][indexPath.row]
        switch item {
            
        case .name:
            if let cell = tableView.cellForRow(at: indexPath) as? TextFieldTableViewCell {
                cell.becomeFirstResponder()
            }
        case .prayer:
            performSegue(withIdentifier: "prayerSelectionSegue", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return nil
        } else if section == 1 {
            return "Selected prayers will show the contents of this group"
        }
        return nil
    }
}

extension AddGroupFormViewController: CellTextDelegate {
    func textChanged(text: String?, indexPath: IndexPath) {
        let item = GroupFormCell.sections[indexPath.section][indexPath.row]
        switch item{
        case .name:
            groupName = text
        case .prayer:
            print("what in the world?")
        }
    }
    
}

extension AddGroupFormViewController: PrayerSelectionDelegate {
    func prayersSelected(prayers: [PrayerModel]) {
        self.selectedPrayers = prayers
    }
}
