//
//  PrayerSelectionViewController.swift
//  PrayerList
//
//  Created by Devin  on 1/12/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import UIKit

protocol PrayerSelectionDelegate: class {
    func prayersSelected(prayers: [PrayerModel])
}

class PrayerSelectionViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var prayers = [PrayerModel]()
    var selectedPrayers = [PrayerModel]()
    
    weak var delegate: PrayerSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: TextFieldTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: TextFieldTableViewCell.reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.backgroundColor = Theme.Color.Background
        prayers = PrayerInterface.retrieveAllPrayers(inContext: CoreDataManager.mainContext)
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.delegate?.prayersSelected(prayers: self.selectedPrayers)
    }

}

extension PrayerSelectionViewController: Instantiatable {
    static var appStoryboard: AppStoryboard {
        return .organiser
    }
}

extension PrayerSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prayers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.reuseIdentifier, for: indexPath) as! TextFieldTableViewCell
        
        let prayer = prayers[indexPath.row]
        cell.delegate = self
        cell.setUp(title: prayers[indexPath.row].name, detail: nil, isEditable: false, indexPath: indexPath)
        cell.accessoryType = selectedPrayers.contains(where: {$0.uuid == prayer.uuid}) ? .checkmark : .none
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
        let prayer = prayers[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)
        if let index = selectedPrayers.firstIndex(where: {$0.uuid == prayer.uuid}) {
            cell?.accessoryType = .none
            selectedPrayers.remove(at: index)
        } else {
            cell?.accessoryType = .checkmark
            selectedPrayers.append(prayer)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Selected the prayers that you would like to associate this category with"
    }
}

extension PrayerSelectionViewController: CellTextDelegate {
    func textChanged(text: String?, indexPath: IndexPath) {
        print("what in the world?")
    }
}
