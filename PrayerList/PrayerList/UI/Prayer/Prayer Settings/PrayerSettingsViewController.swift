//
//  PrayerSettingsViewController.swift
//  PrayerList
//
//  Created by Devin  on 29/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import UIKit
import LocalAuthentication

enum SettingsSection {
    
    case passcode
    
    var rows: [SettingsRow] {
        switch self {
        case .passcode:
            if LAContext.biometricType == .none {
                return PLUserDefaults.requiresPasscode ? [.passcodeState, .setCode] : [.passcodeState]
            } else {
                return PLUserDefaults.requiresPasscode ? [.passcodeState, .biometrics, .setCode] : [.passcodeState]
            }
            
        }
    }
    
    static var sections: [SettingsSection] {
        return [.passcode]
    }
}

enum SettingsRow {
    case passcodeState
    case setCode
    case biometrics
}

class PrayerSettingsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: TextFieldTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: TextFieldTableViewCell.reuseIdentifier)
        
        tableView.register(UINib(nibName: SwitchTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: SwitchTableViewCell.reuseIdentifier)
        
        tableView.register(UINib(nibName: ButtonTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: ButtonTableViewCell.reuseIdentifier)
        
        tableView.estimatedRowHeight = 44
        self.title = "Settings"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = Theme.Color.Background
        tableView.reloadData()
    }
    
    @IBAction func doneAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func togglePasscode(){
        PLUserDefaults.requiresPasscode = !PLUserDefaults.requiresPasscode
        
        if PLUserDefaults.requiresPasscode {
            let passcodeVC = PasscodeViewController.instantiate() as! PasscodeViewController
            passcodeVC.isEditor = true
            self.present(passcodeVC, animated: true, completion: nil)
            
            tableView.beginUpdates()
            tableView.insertRows(at: [IndexPath(row: 1, section: 0), IndexPath(row: 2, section: 0)], with: .automatic)
            tableView.endUpdates()
        } else {
            tableView.beginUpdates()
            tableView.deleteRows(at: [IndexPath(row: 1, section: 0), IndexPath(row: 2, section: 0)], with: .automatic)
            tableView.endUpdates()
            
            PLUserDefaults.passcode = nil
            PLUserDefaults.useBiometrics = false
        }
    }
    
}

extension PrayerSettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = SettingsSection.sections[section]
        return section.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = SettingsSection.sections[indexPath.section]
        let row = section.rows[indexPath.row]
        switch row {
        case .passcodeState:
            let cell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.reuseIdentifier, for: indexPath) as! SwitchTableViewCell
            cell.setUp(title: "Require Passcode", switchState: PLUserDefaults.requiresPasscode, indexPath: indexPath)
            cell.delegate = self
            return cell
        case .setCode:
            let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.reuseIdentifier, for: indexPath) as! ButtonTableViewCell
            cell.setUp(buttonText: "Change Passcode", textColor: Theme.Color.PrimaryTint)
            return cell
        case .biometrics:
            let cell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.reuseIdentifier, for: indexPath) as! SwitchTableViewCell
            cell.setUp(title: "Use \(LAContext.biometricType.rawValue)", switchState: PLUserDefaults.useBiometrics, indexPath: indexPath)
            cell.delegate = self
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
        let section = SettingsSection.sections[indexPath.section]
        let row = section.rows[indexPath.row]
        
        switch row {
        case .passcodeState:
            if let cell = tableView.cellForRow(at: indexPath) as? SwitchTableViewCell {
                togglePasscode()
                cell.switchControl.setOn(PLUserDefaults.requiresPasscode, animated: true)
            }
        case .setCode:
            let passcodeVC = PasscodeViewController.instantiate() as! PasscodeViewController
            passcodeVC.isEditor = true
            self.present(passcodeVC, animated: true, completion: nil)
        case .biometrics:
            PLUserDefaults.useBiometrics = !PLUserDefaults.useBiometrics
            if let cell = tableView.cellForRow(at: indexPath) as? SwitchTableViewCell {
                cell.switchControl.setOn(PLUserDefaults.useBiometrics, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionType = SettingsSection.sections[section]
        switch sectionType {
        case .passcode:
            return "Passcode"
        }
    }
}

extension PrayerSettingsViewController: SwitchCellDelegate {
    func switchToggled(indexPath: IndexPath) {
        let section = SettingsSection.sections[indexPath.section]
        let row = section.rows[indexPath.row]
        switch row {
        case .passcodeState:
            togglePasscode()
        case .setCode:
            print("Why you be here?")
        case .biometrics:
            PLUserDefaults.useBiometrics = !PLUserDefaults.useBiometrics
        }
    }
}

extension PrayerSettingsViewController: CellTextDelegate {
    func textChanged(text: String?, indexPath: IndexPath) {
        
    }
}
