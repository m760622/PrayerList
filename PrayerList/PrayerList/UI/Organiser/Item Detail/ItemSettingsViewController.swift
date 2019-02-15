//
//  ItemSettingsViewController.swift
//  PrayerList
//
//  Created by Devin  on 16/02/19.
//  Copyright © 2019 Devin Davies. All rights reserved.
//

import UIKit

enum ItemSettingsCell {
    case name
    case delete
    
    static var sections: [[ItemSettingsCell]] {
        return [[.name], [.delete]]
    }
}


class ItemSettingsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var item: ItemModel!
    
    weak var delegate: SettingsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: TextFieldTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: TextFieldTableViewCell.reuseIdentifier)
        
        // Do any additional setup after loading the view.
    }
    
    func deleteItem(){
        let alert = UIAlertController(title: "Delete Item", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (deleteAction) in
            self.delete()
        }))
        
        alert.view.tintColor = Theme.Color.PrimaryTint
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func delete(){
        ItemInterface.deleteGroup(group: item, inContext: CoreDataManager.mainContext)
        
        self.dismiss(animated: true, completion: nil)
        self.delegate?.thingDeleted()
    }
    
    @IBAction func doneAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension ItemSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return ItemSettingsCell.sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ItemSettingsCell.sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = ItemSettingsCell.sections[indexPath.section][indexPath.row]
        
        switch item {
        case .name:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.reuseIdentifier, for: indexPath) as! TextFieldTableViewCell
            cell.delegate = self
            
            cell.setUp(title: "Name", detail: self.item.name, placeholder: "Name", isEditable: true, indexPath: indexPath)
            cell.accessoryType = .none
            return cell
        case .delete:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.reuseIdentifier, for: indexPath) as! TextFieldTableViewCell
            cell.delegate = self
            cell.setUp(title: "Delete", detail: nil, isEditable: false, indexPath: indexPath, titleColor: Theme.Color.Error)
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
        let item = ItemSettingsCell.sections[indexPath.section][indexPath.row]
        switch item {
            
        case .name:
            if let cell = tableView.cellForRow(at: indexPath) as? TextFieldTableViewCell {
                cell.becomeFirstResponder()
            }
        case .delete:
            deleteItem()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return nil
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
}



extension ItemSettingsViewController: CellTextDelegate {
    func textChanged(text: String?, indexPath: IndexPath) {
        guard let text = text else { return }
        let cellItem = ItemSettingsCell.sections[indexPath.section][indexPath.row]
        switch cellItem {
        case .name:
            item.name = text
            ItemInterface.saveGroup(group: item, inContext: CoreDataManager.mainContext)
            delegate?.nameUpdated(name: text)
        case .delete:
            fatalError("Not a text cell")
        }
    }
}



