//
//  AddCategoryViewController.swift
//  PrayerList
//
//  Created by Devin  on 22/12/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import UIKit

enum CategoryFormCell {
    case name
    case prayer
    
    static var sections: [CategoryFormCell] {
        return [.name, .prayer]
    }
}

class AddCategoryViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedPrayers = [PrayerModel]()
    var name: String?
    
    var isFreshLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: TextFieldTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: TextFieldTableViewCell.reuseIdentifier)
        // Do any additional setup after loading the view.
        updateNavButtons()
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
    
    @IBAction func doneActio(_ sender: Any) {
        if let name = self.name {
            
            let newCategory = CategoryModel(name: name, order: CategoryInterface.retrieveAllCategories(inContext: CoreDataManager.mainContext).count)
            newCategory.prayers = self.selectedPrayers
            CategoryInterface.saveCategory(category: newCategory, inContext: CoreDataManager.mainContext)
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? PrayerSelectionViewController {
            self.view.endEditing(true)
            destVC.selectedPrayers = self.selectedPrayers
            destVC.delegate = self
        }
    }
    
    func updateNavButtons(){
        if let text = name, !text.isEmpty {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
}

extension AddCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return CategoryFormCell.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.reuseIdentifier, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? TextFieldTableViewCell {
            cell.delegate = self
            
            switch CategoryFormCell.sections[indexPath.section] {
            case .name:
                cell.setUp(title: "Name", detail: self.name, placeholder: "Name", isEditable: true, indexPath: indexPath)
                cell.accessoryType = .none
            case .prayer:
                let detailText = selectedPrayers.count > 1 ? "\(selectedPrayers.count) Selected" : selectedPrayers.first?.name
                cell.setUp(title: "Prayers", detail: detailText, placeholder: "Select prayers", isEditable: false, indexPath: indexPath, detailColor: Theme.Color.Subtitle)
                cell.accessoryType = .disclosureIndicator
            }
        }
        
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
        let item = CategoryFormCell.sections[indexPath.section]
        switch item {
        case .name:
            if let cell = tableView.cellForRow(at: indexPath) as? TextFieldTableViewCell {
                cell.becomeFirstResponder()
            }
        case .prayer:
            let vc = PrayerSelectionViewController.instantiate() as! PrayerSelectionViewController
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension AddCategoryViewController: CellTextDelegate {
    func textChanged(text: String?, indexPath: IndexPath) {
        let item = CategoryFormCell.sections[indexPath.section]
        switch item{
        case .name:
            name = text
            self.updateNavButtons()
        case .prayer:
            print("what in the world?")
        }
    }
    
}

extension AddCategoryViewController: PrayerSelectionDelegate {
    func prayersSelected(prayers: [PrayerModel]) {
        self.selectedPrayers = prayers
    }
}
