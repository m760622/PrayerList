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
    
    case showEmpty
    case count
    case setType
    
    static var sections: [[CategorySettingsCell]] {
        return [[.name, .prayer], [.setType, .count, .showEmpty], [.delete]]
    }
}

class CategorySettingsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var category: CategoryModel!
    
    weak var delegate: SettingsDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Category Settings"
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: TextFieldTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: TextFieldTableViewCell.reuseIdentifier)
        
        tableView.register(UINib(nibName: SwitchTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: SwitchTableViewCell.reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        CategoryInterface.saveCategory(category: category, inContext: CoreDataManager.mainContext)
    }
    
    func deleteCategory(){
        let alert = UIAlertController(title: "Delete Category", message: "Are you sure you want to delete this category? You will lose all the related items & notes", preferredStyle: .alert)
        
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
        let item = CategorySettingsCell.sections[indexPath.section][indexPath.row]
        
        switch item {
        case .name:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.reuseIdentifier, for: indexPath) as! TextFieldTableViewCell
            cell.delegate = self
            
            cell.setUp(title: "Name", detail: self.category.name, placeholder: "Name", isEditable: true, indexPath: indexPath)
            cell.accessoryType = .none
            return cell
        case .prayer:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.reuseIdentifier, for: indexPath) as! TextFieldTableViewCell
            cell.delegate = self
            let detailText = category.prayers.count > 1 ? "\(category.prayers.count) Selected" : category.prayers.first?.name
            cell.setUp(title: "Prayers", detail: detailText, placeholder: "Select prayers", isEditable: false, indexPath: indexPath, detailColor: Theme.Color.Subtitle)
            cell.accessoryType = .disclosureIndicator
            return cell
        case .delete:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.reuseIdentifier, for: indexPath) as! TextFieldTableViewCell
            cell.delegate = self
            cell.setUp(title: "Delete", detail: nil, isEditable: false, indexPath: indexPath, titleColor: Theme.Color.Error)
            return cell
        case .count:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.reuseIdentifier, for: indexPath) as! TextFieldTableViewCell
            cell.delegate = self
            let detailText = "\(category.totalPerSet)"
            cell.setUp(title: "Items Per Prayer", detail: detailText, placeholder: "Count", isEditable: true, indexPath: indexPath, detailColor: Theme.Color.Subtitle, keyboardType: UIKeyboardType.numberPad)
            cell.accessoryType = .none
            return cell
        case .showEmpty:
            let cell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.reuseIdentifier, for: indexPath) as! SwitchTableViewCell
            cell.setUp(title: "Show Empty Items", switchState: category.showEmptyItems, indexPath: indexPath)
            cell.delegate = self
            return cell
        case .setType:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.reuseIdentifier, for: indexPath) as! TextFieldTableViewCell
            cell.delegate = self
            let detailText = category.setType.title
            cell.setUp(title: "Sort Type", detail: detailText, placeholder: "Select Type", isEditable: false, indexPath: indexPath, detailColor: Theme.Color.Subtitle)
            cell.accessoryType = .disclosureIndicator
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //Top Left Right Corners
        let maskPathTop = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 12.0, height: 12.0))
        let shapeLayerTop = CAShapeLayer()
        shapeLayerTop.frame = cell.bounds
        shapeLayerTop.path = maskPathTop.cgPath
        
        //Bottom Left Right Corners
        let maskPathBottom = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 12.0, height: 12.0))
        let shapeLayerBottom = CAShapeLayer()
        shapeLayerBottom.frame = cell.bounds
        shapeLayerBottom.path = maskPathBottom.cgPath
        
        //All Corners
        let maskPathAll = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: [.topLeft, .topRight, .bottomRight, .bottomLeft], cornerRadii: CGSize(width: 12.0, height: 12.0))
        let shapeLayerAll = CAShapeLayer()
        shapeLayerAll.frame = cell.bounds
        shapeLayerAll.path = maskPathAll.cgPath
        
        if (indexPath.row == 0 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section)-1)
        {
            cell.layer.mask = shapeLayerAll
        }
        else if (indexPath.row == 0)
        {
            cell.layer.mask = shapeLayerTop
        }
        else if (indexPath.row == tableView.numberOfRows(inSection: indexPath.section)-1)
        {
            cell.layer.mask = shapeLayerBottom
        }
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
        case .showEmpty:
            print("hhhfh")
        case .count:
            print("hhhfh")
        case .setType:
            let sortController = CategorySortSelectionController.instantiate() as! CategorySortSelectionController
            sortController.category = category
            self.navigationController?.pushViewController(sortController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return nil
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Prayer Settings"
        } else if section == 0 {
            return "Detials"
        }
        
        return nil
    }
}

extension CategorySettingsViewController: CellTextDelegate {
    func textChanged(text: String?, indexPath: IndexPath) {
        guard let text = text else { return }
        let item = CategorySettingsCell.sections[indexPath.section][indexPath.row]
        switch item {
        case .name:
            category.name = text
            CategoryInterface.saveCategory(category: category, inContext: CoreDataManager.mainContext)
            delegate?.nameUpdated(name: text)
        case .prayer:
            print("what in the world?")
        case .delete:
            print("what in the world?")
        case .showEmpty:
            print("what in the world?")
        case .count:
            if let newCount = Int(text){
                category.totalPerSet = newCount
            }
        case .setType:
            print("what in the world?")
        }
    }
    
}

extension CategorySettingsViewController: SwitchCellDelegate {
    func switchToggled(indexPath: IndexPath) {
        let item = CategorySettingsCell.sections[indexPath.section][indexPath.row]
        
        if item == .showEmpty {
            category.showEmptyItems = !category.showEmptyItems
            CategoryInterface.saveCategory(category: category, inContext: CoreDataManager.mainContext)
        }
    }
}

extension CategorySettingsViewController: PrayerSelectionDelegate {
    func prayersSelected(prayers: [PrayerModel]) {
        self.category.updatePrayerSelection(prayers: prayers)
        CategoryInterface.saveCategory(category: category, inContext: CoreDataManager.mainContext)
    }
}
