//
//  PRUserDefaults.swift
//  PrayerList
//
//  Created by Devin  on 30/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import Foundation

public class PLUserDefaults {
    static var hasSetUp: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "IS_FIRST_RUN")
        }
        get {
            return UserDefaults.standard.bool(forKey: "IS_FIRST_RUN")
        }
    }
}
