//
//  Storyboardable.swift
//  PrayerList
//
//  Created by Devin  on 1/12/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import Foundation
import UIKit

enum AppStoryboard: String {
    case prayer = "Prayer"
    case organiser = "Organiser"
}

protocol Instantiatable: class {
    static var appStoryboard: AppStoryboard { get }
}

extension Instantiatable where Self: UIViewController {
    
    static func instantiate<T: UIViewController>() -> T {
        let storyboard = UIStoryboard(name: Self.appStoryboard.rawValue, bundle: nil)
        let identifier = String(describing: self)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
}
