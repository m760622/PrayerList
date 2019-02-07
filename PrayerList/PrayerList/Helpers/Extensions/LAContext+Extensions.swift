//
//  LAContext+Extensions.swift
//  PrayerList
//
//  Created by Devin  on 7/02/19.
//  Copyright © 2019 Devin Davies. All rights reserved.
//

import Foundation
import LocalAuthentication

extension LAContext {
    
    enum BiometricType: String {
        case none = ""
        case touchID = "Touch ID"
        case faceID = "Face ID"
    }
    
    static var biometricType: BiometricType {
        var error: NSError?
        
        let context = LAContext()
        
        _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        if error?.code == LAError.Code.touchIDNotAvailable.rawValue {
            return .none
        }
        
        if #available(iOS 11.0, *) {
            switch context.biometryType {
            case .none:
                return .none
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
            }
        } else {
            return  context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touchID : .none
        }
    }
}
