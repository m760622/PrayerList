//
//  PrayerDetailViewController.swift
//  PrayerList
//
//  Created by Devin  on 29/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import UIKit

protocol PrayerProgressDelegate: class {
    func progressUpdated(categoriesCompleted: Int)
}

class PrayerPageViewController: UIPageViewController {
    
    var completeButton: UIBarButtonItem!
    
    var prayerManager: PrayerSessionManager!
    
    var controllers = [PrayerSectionViewController]()
    
    weak var progressDelegate: PrayerProgressDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadControllers()
        
        delegate = self
        dataSource = self
    }
    
    func loadControllers(){
        
        if prayerManager.sections != 0 {
            for category in prayerManager.categories {
                if !category.items.filter({!$0.currentNotes.isEmpty}).isEmpty {
                    let controller = PrayerSectionViewController.instantiate() as! PrayerSectionViewController
                    controller.category = category
                    
                    controller.prayerManager = self.prayerManager
                    controllers.append(controller)
                }
            }
            
            if let firstCategory = self.controllers.first {
                setViewControllers([firstCategory], direction: .forward, animated: true, completion: nil)
            }
        } else {
            let controller = PrayerSectionViewController.instantiate() as! PrayerSectionViewController
            setViewControllers([controller], direction: .forward, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func doneAction() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PrayerPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? PrayerSectionViewController, let index = controllers.index(of: viewController), index - 1 >= 0 {
            return controllers[index - 1]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? PrayerSectionViewController, let index = controllers.index(of: viewController), index + 1 < controllers.count {
            return controllers[index + 1]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if finished {
            if let currentView = pageViewController.viewControllers?.first as? PrayerSectionViewController {
                if let index = controllers.index(of: currentView) {
                    progressDelegate?.progressUpdated(categoriesCompleted: index + 1)
                }
            }
        }
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return prayerManager.sections
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
}

protocol SettingsDelegate: class {
    func thingDeleted()
    func nameUpdated(name: String)
}
