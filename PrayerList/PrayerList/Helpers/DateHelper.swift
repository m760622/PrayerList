//
//  DateHelper.swift
//  PrayerList
//
//  Created by Devin  on 29/01/19.
//  Copyright © 2019 Devin Davies. All rights reserved.
//

import Foundation

class DateHelper {
    class func getStringFromDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}
