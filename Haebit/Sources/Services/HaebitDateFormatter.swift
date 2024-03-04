//
//  HaebitDateFormatter.swift
//  HaebitDev
//
//  Created by Seunghun on 3/5/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation

final class HaebitDateFormatter {
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        return dateFormatter
    }()
    
    private let relativeDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .full
        dateFormatter.doesRelativeDateFormatting = true
        return dateFormatter
    }()
    
    func format(date: Date) -> HaebitFormattedDateString {
        var dateString = ""
        var timeString = ""
        
        if date.isToday || date.isYesterday {
            dateString = relativeDateFormatter.string(from: date)
        } else if date.isInAWeek {
            dateFormatter.setLocalizedDateFormatFromTemplate("EEEE")
            dateString = dateFormatter.string(from: date)
        } else if date.isThisYear {
            dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd")
            dateString =  dateFormatter.string(from: date)
        } else {
            dateFormatter.setLocalizedDateFormatFromTemplate("MMMMdy")
            dateString =  dateFormatter.string(from: date)
        }
        
        dateFormatter.setLocalizedDateFormatFromTemplate("HHmm")
        timeString = dateFormatter.string(from: date)
        
        return HaebitFormattedDateString(date: dateString, time: timeString)
    }
}

struct HaebitFormattedDateString {
    let date: String
    let time: String
}

extension Date {
    var isThisYear: Bool { Calendar.current.isDate(self, equalTo: Date(), toGranularity: .year) }
    var isYesterday: Bool { Calendar.current.isDateInYesterday(self) }
    var isToday: Bool { Calendar.current.isDateInToday(self) }
    var isInAWeek: Bool {
        guard let diff = Calendar.current.dateComponents([.year, .month, .day], from: self,  to: Date()).day else {
            return false
        }
        return diff <= 7 && diff >= 0
    }
}
