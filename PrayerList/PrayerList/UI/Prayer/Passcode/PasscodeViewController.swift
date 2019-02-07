//
//  PasscodeViewController.swift
//  PrayerList
//
//  Created by Devin  on 6/02/19.
//  Copyright © 2019 Devin Davies. All rights reserved.
//

import UIKit
import LocalAuthentication

class PasscodeViewController: BaseViewController {

    @IBOutlet weak var dotsStack: UIStackView!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var dotOne: PassCodeDot!
    @IBOutlet weak var dotTwo: PassCodeDot!
    @IBOutlet weak var dotThree: PassCodeDot!
    @IBOutlet weak var dotFour: PassCodeDot!
    
    var passcode = [Int]()
    var checkPasscode = [Int]()
    
    var currentPasscodeAttempt: [Int] {
        return isValidating ? checkPasscode : passcode
    }
    
    var isEditor = false
    var isValidating = false
    
    var hasTriedBio = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deleteButton.setTitleColor(Theme.Color.Red, for: .normal)
        
        if isEditor {
            titleLabel.text = "Create Passcode"
            subtitleLabel.text = "Enter a passcode"
        } else {
            titleLabel.text = "Passcode"
            subtitleLabel.text = "Enter your passcode to unlock"
        }
        
        titleLabel.textColor = Theme.Color.Text
        subtitleLabel.textColor = Theme.Color.Subtitle

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !isEditor && PLUserDefaults.useBiometrics && !hasTriedBio {
            hasTriedBio = true
            let context = LAContext()
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "what?") { (success, error) in
                    if success {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        print("it's not you")
                    }
                }
            }
        }
    }
    
    func reset(){
        dotOne.setInactive()
        dotTwo.setInactive()
        dotThree.setInactive()
        dotFour.setInactive()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        if isEditor {
            self.dismiss(animated: true, completion: nil)
        } else {
            passcode.removeAll()
            reset()
        }
    }
    
    @IBAction func backspaceAction(_ sender: Any) {
        
        if isValidating && !checkPasscode.isEmpty {
             checkPasscode.removeLast()
        } else if !passcode.isEmpty {
            passcode.removeLast()
        }
        
        downDots()
    }
    
    @IBAction func buttonPressed(_ sender: PasscodeButton) {
        if isValidating && checkPasscode.count < 4 {
            checkPasscode.append(sender.number)
        } else if passcode.count < 4 {
            passcode.append(sender.number)
        }
        
        upDots()
        
        if currentPasscodeAttempt.count == 4 {
            proccessPasscode()
        }
    }
    
    func proccessPasscode(){
        if isEditor {
            if checkPasscode.isEmpty {
                isValidating = true
                reset()
                titleLabel.text = "Re-enter Passcode"
                subtitleLabel.text = "Re-enter your passcode to verify"
            } else {
                if passcode.map({"\($0)"}).joined() == checkPasscode.map({"\($0)"}).joined() {
                    PLUserDefaults.passcode = passcode.map({"\($0)"}).joined()
                    self.dismiss(animated: true, completion: nil)
                } else {
                    checkPasscode.removeAll()
                    passcode.removeAll()
                    isValidating = false
                    reset()
                    titleLabel.text = "Enter New Passcode"
                    subtitleLabel.text = "Passcodes didn't match, try again"
                }
            }
        } else {
            if passcode.map({"\($0)"}).joined() == PLUserDefaults.passcode {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func downDots(){
        if currentPasscodeAttempt.count == 0 {
            dotOne.setInactive()
        } else if currentPasscodeAttempt.count == 1 {
            dotTwo.setInactive()
        } else if currentPasscodeAttempt.count == 2 {
            dotThree.setInactive()
        } else if currentPasscodeAttempt.count == 3 {
            dotFour.setInactive()
        }
    }
    
    func upDots(){
        if currentPasscodeAttempt.count == 1 {
            dotOne.setActive()
        } else if currentPasscodeAttempt.count == 2 {
            dotTwo.setActive()
        } else if currentPasscodeAttempt.count == 3 {
            dotThree.setActive()
        } else if currentPasscodeAttempt.count == 4 {
            dotFour.setActive()
        }
    }

}

extension PasscodeViewController: Instantiatable {
    static var appStoryboard: AppStoryboard {
        return AppStoryboard.prayer
    }
    
    
}
