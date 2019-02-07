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
    
    static var requiresPasscode: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "REQUIRES_PASSCODE")
        }
        get {
            return UserDefaults.standard.bool(forKey: "REQUIRES_PASSCODE")
        }
    }
    
    static var useBiometrics: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "USE_BIOMETRICS")
        }
        get {
            return UserDefaults.standard.bool(forKey: "USE_BIOMETRICS")
        }
    }
    
    static var passcode: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "PASSCODE")
        }
        get {
            return UserDefaults.standard.string(forKey: "PASSCODE")
        }
    }
    
    static var timeExited: Date? {
        set {
            UserDefaults.standard.set(newValue, forKey: "TIME_EXITED")
        }
        get {
            if let dateObejct = UserDefaults.standard.object(forKey: "TIME_EXITED") as? Date {
                return dateObejct
            }
            return nil
        }
    }
}
