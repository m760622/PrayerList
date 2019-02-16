//
//  PrayerSettingsViewController.swift
//  PrayerList
//
//  Created by Devin  on 16/02/19.
//  Copyright © 2019 Devin Davies. All rights reserved.
//

import UIKit

enum PrayerSettingsRow {
    case name
    case delete
    
    static var sections: [[PrayerSettingsRow]]{
        return [[.name], [.delete]]
    }
}

class PrayerSettingsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var selectedPrayer: PrayerModel!
    
    weak var delegate: PrayerSettingsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.register(UINib(nibName: TextFieldTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: TextFieldTableViewCell.reuseIdentifier)
        
        tableView.register(UINib(nibName: SwitchTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: SwitchTableViewCell.reuseIdentifier)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
        PrayerInterface.savePrayer(prayer: selectedPrayer, inContext: CoreDataManager.mainContext)
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
        PrayerInterface.deletePrayer(prayerModel: selectedPrayer, inContext: CoreDataManager.mainContext)
        self.delegate?.prayerDeleted(prayer: selectedPrayer)
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func doneAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension PrayerSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return PrayerSettingsRow.sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PrayerSettingsRow.sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = PrayerSettingsRow.sections[indexPath.section][indexPath.row]
        
        switch item {
        case .name:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.reuseIdentifier, for: indexPath) as! TextFieldTableViewCell
            cell.delegate = self
            
            cell.setUp(title: "Name", detail: self.selectedPrayer.name, placeholder: "Name", isEditable: true, indexPath: indexPath)
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
        let item = PrayerSettingsRow.sections[indexPath.section][indexPath.row]
        switch item {
        case .name:
            if let cell = tableView.cellForRow(at: indexPath) as? TextFieldTableViewCell {
                cell.becomeFirstResponder()
            }
        case .delete:
            deletePrayer()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return nil
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Detials"
        }
        
        return nil
    }
}

extension PrayerSettingsViewController: CellTextDelegate {
    func textChanged(text: String?, indexPath: IndexPath) {
        guard let text = text else { return }
        let item = PrayerSettingsRow.sections[indexPath.section][indexPath.row]
        switch item {
        case .name:
            selectedPrayer.name = text
        case .delete:
            print("what in the world?")
        }
    }
}

extension PrayerSettingsViewController: SwitchCellDelegate {
    func switchToggled(indexPath: IndexPath) {
     
    }
}

