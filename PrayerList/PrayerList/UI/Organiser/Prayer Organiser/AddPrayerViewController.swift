//
//  AddPrayerViewController.swift
//  PrayerList
//
//  Created by Devin  on 16/02/19.
//  Copyright © 2019 Devin Davies. All rights reserved.
//

import Foundation
import UIKit

enum PrayerFormCell {
    case name
    
    static var sections: [PrayerFormCell] {
        return [.name]
    }
}

class AddPrayerViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var prayerName: String?
    
    var isFreshLoad = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.register(UINib(nibName: TextFieldTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: TextFieldTableViewCell.reuseIdentifier)
        
        tableView.estimatedRowHeight = 44
        self.updateNavButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
        if isFreshLoad {
            isFreshLoad = false
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TextFieldTableViewCell {
                cell.textField.becomeFirstResponder()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    func setUpPrayer(){
        if let name = prayerName, !name.isEmpty {
            let count = PrayerInterface.retrieveAllPrayers(inContext: CoreDataManager.mainContext).count
            let prayer = PrayerModel(name: name, order: count)
            
            PrayerInterface.savePrayer(prayer: prayer, inContext: CoreDataManager.mainContext)
        }
    }
    
    func updateNavButtons(){
        if let text = self.prayerName, !text.isEmpty {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    @IBAction func addAction(_ sender: Any) {
        self.view.endEditing(true)
        setUpPrayer()
        self.dismiss(animated: true)
        
    }
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension AddPrayerViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return PrayerFormCell.sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch PrayerFormCell.sections[section] {
        case .name:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = PrayerFormCell.sections[indexPath.section]
        switch item {
        case .name:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.reuseIdentifier, for: indexPath) as! TextFieldTableViewCell
            cell.delegate = self
            cell.setUp(title: "Title", detail: self.prayerName, placeholder: "Add title", isEditable: true, indexPath: indexPath)
            cell.accessoryType = .none
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
        let item = PrayerFormCell.sections[indexPath.section]
        switch item {
        case .name:
            if let cell = tableView.cellForRow(at: indexPath) as? TextFieldTableViewCell {
                cell.becomeFirstResponder()
            }
        }
    }
}

extension AddPrayerViewController: CellTextDelegate {
    func textChanged(text: String?, indexPath: IndexPath) {
        let item = PrayerFormCell.sections[indexPath.section]
        switch item {
        case .name:
            prayerName = text
            self.updateNavButtons()
        }
    }
    
}
