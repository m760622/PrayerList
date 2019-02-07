//
//  CategorySortSelectionController.swift
//  PrayerList
//
//  Created by Devin  on 6/02/19.
//  Copyright © 2019 Devin Davies. All rights reserved.
//

import UIKit

class CategorySortSelectionController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var category: CategoryModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Order Type"

        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: TextFieldTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: TextFieldTableViewCell.reuseIdentifier)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CategorySortSelectionController: Instantiatable {
    static var appStoryboard: AppStoryboard {
        return .organiser
    }
}

extension CategorySortSelectionController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SetType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = SetType.allCases[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.reuseIdentifier, for: indexPath) as! TextFieldTableViewCell
        cell.delegate = self
        cell.tintColor = Theme.Color.PrimaryTint
        cell.setUp(title: type.title, detail: nil, isEditable: false, indexPath: indexPath)
        cell.accessoryType = type == category.setType ? .checkmark : .none
        return cell
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
        let type = SetType.allCases[indexPath.row]
        category.setType = type
        CategoryInterface.saveCategory(category: category, inContext: CoreDataManager.mainContext)
        
        let selectedCell = tableView.cellForRow(at: indexPath)
        selectedCell?.accessoryType = .checkmark
        for cell in tableView.visibleCells {
            if cell != selectedCell {
                cell.accessoryType = .none
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Consecutive: Items will appear in prayers in the order they appear in the organiser\n\nRandom: Items will appear in prayers in a random order"
    }
}

extension CategorySortSelectionController: CellTextDelegate {
    func textChanged(text: String?, indexPath: IndexPath) {
        print("what in the world?")
    }
}

