//
//  CategorySettingsViewController.swift
//  PrayerList
//
//  Created by Devin  on 1/12/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import UIKit

enum CategorySettingsCell {
    case name
    case prayer
    case delete
    
    static var sections: [[CategorySettingsCell]] {
        return [[.name, .prayer], [.delete]]
    }
}

class CategorySettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var category: PrayerCategoryModel!
    
    weak var delegate: SettingsDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: TextFieldTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: TextFieldTableViewCell.reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func deleteCategory(){
        let alert = UIAlertController(title: "Delete Category", message: "Are you sure you want to delete this category? You will loose all the related information", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (deleteAction) in
            self.delete()
        }))
        
        alert.view.tintColor = Theme.Color.PrimaryTint
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func delete(){
        CategoryInterface.deleteCategory(category: category, inContext: CoreDataManager.mainContext)
        
        self.dismiss(animated: true, completion: nil)
        self.delegate?.thingDeleted()
    }
    
    @IBAction func doneAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CategorySettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return CategorySettingsCell.sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CategorySettingsCell.sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.reuseIdentifier, for: indexPath) as! TextFieldTableViewCell
        cell.delegate = self
        let item = CategorySettingsCell.sections[indexPath.section][indexPath.row]
        switch item {
            
        case .name:
            cell.setUp(title: "Name", detail: self.category.name, placeholder: "Name", isEditable: true, indexPath: indexPath)
            cell.accessoryType = .none
        case .prayer:
            let detailText = category.prayers.count > 1 ? "\(category.prayers.count) Selected" : category.prayers.first?.name
            cell.setUp(title: "Prayers", detail: detailText, placeholder: "Select prayers", isEditable: false, indexPath: indexPath, detailColor: Theme.Color.Subtitle)
            cell.accessoryType = .disclosureIndicator
        case .delete:
            cell.setUp(title: "Delete", detail: nil, isEditable: false, indexPath: indexPath, titleColor: Theme.Color.Error)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = CategorySettingsCell.sections[indexPath.section][indexPath.row]
        switch item {
            
        case .name:
            if let cell = tableView.cellForRow(at: indexPath) as? TextFieldTableViewCell {
                cell.becomeFirstResponder()
            }
        case .prayer:
            let prayerSelectionController = PrayerSelectionViewController.instantiate() as! PrayerSelectionViewController
            prayerSelectionController.delegate = self
            prayerSelectionController.selectedPrayers = category.prayers
            self.navigationController?.pushViewController(prayerSelectionController, animated: true)
        case .delete:
            deleteCategory()
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

extension CategorySettingsViewController: CellTextDelegate {
    func textChanged(text: String?, indexPath: IndexPath) {
        guard let text = text else { return }
        let item = CategorySettingsCell.sections[indexPath.section][indexPath.row]
        switch item{
        case .name:
            category.name = text
            CategoryInterface.saveCategory(category: category, inContext: CoreDataManager.mainContext)
            delegate?.nameUpdated(name: text)
        case .prayer:
            print("what in the world?")
        case .delete:
            print("what in the world?")
        }
    }
    
}

extension CategorySettingsViewController: PrayerSelectionDelegate {
    func prayersSelected(prayers: [PrayerModel]) {
        self.category.prayers = prayers
        CategoryInterface.saveCategory(category: category, inContext: CoreDataManager.mainContext)
    }
}
