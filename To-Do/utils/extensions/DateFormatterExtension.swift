//
//  DateFormatterExtension.swift
//  Haulio
//
//  Created by Duy Nguyen on 8/6/18.
//  Copyright © 2018 Haulio Pte Ltd. All rights reserved.
//

import Foundation

struct XTDateFormatterStruct {
    
    static var localeIdentifier: String {
            return "en_US"
    }
    
    static var shortDateFormat: String {
            return "dd MMMM yyyy"
        }
    
    static var fullDateTimeFormat: String {

            return "EEE, dd MMM yyyy HH:mm a"
        
    }
    
    static let formatter: DateFormatter = {
        return getDateFormatter()
    }()
    
    static func getDateFormatterEnglishOnly(dateFormat: String? = nil, chineseDateFormat: String? = nil) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = dateFormat
        return formatter
    }
    
    static func getDateFormatter(dateFormat: String? = nil, chineseDateFormat: String? = nil) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: localeIdentifier)
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = dateFormat
        return formatter
    }
    
    static func xt_defaultDateFormatter() -> DateFormatter {
        return getDateFormatter(dateFormat: "dd/MM/yyyy")
    }
    
    static func xt_defaultDateTimeFormatter() -> DateFormatter {
        return getDateFormatter(dateFormat: "dd-MM-yyyy h:mm a")
    }
    
    static func xt_TaskDateFormatter() -> DateFormatter {
        return getDateFormatter(dateFormat: "d MMM yyyy")
    }
    
    static func xt_serverDateFormatter() -> DateFormatter {
        return getDateFormatter(dateFormat: "yyyy-MM-dd")
    }
    
    static func xt_appDateFormatter() -> DateFormatter {
        return getDateFormatter(dateFormat: "EEEE, dd MMMM yyyy", chineseDateFormat: "EEE, yyyy 年 MMM dd 日")
    }
    
    static func xt_appDateFormatterEnglishOnly() -> DateFormatter {
        return getDateFormatterEnglishOnly(dateFormat: "EEEE, dd MMM yyyy")
    }
    
    static func xt_appShortDateFormatter() -> DateFormatter {
        return getDateFormatter(dateFormat: "EEE, dd MMM yyyy", chineseDateFormat: "EEE, yyyy 年 MMM dd 日")
    }
    
    static func xt_appDateTimeFormatter() -> DateFormatter {
        return getDateFormatter(dateFormat: fullDateTimeFormat, chineseDateFormat: fullDateTimeFormat)
    }
    
    static func xt_fullDateFormatter() -> DateFormatter {
        return getDateFormatter(dateFormat: "yyyy-MM-dd'T'HH:mm:ssZZZ")
    }

    static func xt_fullLongDateFormatter() -> DateFormatter {
        return getDateFormatter(dateFormat: "yyyy-MM-dd'T'HH:mm:ssZZZZZ")
    }
    
    static func xt_fullLongDateFormatterEnglishOnly() -> DateFormatter {
        return getDateFormatterEnglishOnly(dateFormat: "yyyy-MM-dd'T'HH:mm:ssZZZZZ")
    }
    
    static func xt_12HourFormatTimeFormatter() -> DateFormatter {
        return getDateFormatterEnglishOnly(dateFormat: "h : mm a")
    }
    
    static func xt_24HourFormatTimeFormatter() -> DateFormatter {
        return getDateFormatterEnglishOnly(dateFormat: "hh : mm")
    }
    
    static func xt_shortDateFormatter() -> DateFormatter {
        return getDateFormatter(dateFormat: shortDateFormat, chineseDateFormat: shortDateFormat)
    }
    
    static func xt_dateFormatter(_ format: String!) -> DateFormatter {
        return getDateFormatter(dateFormat: format, chineseDateFormat: format)
    }
    
    static func xt_dateFormatterEnglishOnly(_ format: String!) -> DateFormatter {
        return getDateFormatterEnglishOnly(dateFormat: format, chineseDateFormat: format)
    }
    
}

extension DateFormatter {
    func xt_stringFromDate(_ date: Date?) -> String? {
        guard let date = date else {
            return nil
        }
        return string(from: date)
    }
    
    func xt_convertToSGDateTime(_ date: Date?) -> String? {
        guard let date = date else {
            return nil
        }
        let timeZone = TimeZone(abbreviation: "SGT")!
        self.timeZone = timeZone
        return string(from: date)
    }
    
    func xt_formatDateTime(_ dateTime: String?, format: String = XTDateFormatterStruct.shortDateFormat) -> String? {
        guard let dateTime = dateTime else { return nil }
        if let date = self.date(from: dateTime) {
            let dateFormatter = XTDateFormatterStruct.xt_dateFormatter(format)
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    func xt_formatDateTimeEnglishOnly(_ dateTime: String?, format: String = XTDateFormatterStruct.shortDateFormat) -> String? {
        guard let dateTime = dateTime else { return nil }
        if let date = self.date(from: dateTime) {
            let dateFormatter = XTDateFormatterStruct.xt_dateFormatterEnglishOnly(format)
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    func xt_convrtToDate(_ dateStr: String) -> Date {
        let dateFormatter = XTDateFormatterStruct.xt_defaultDateTimeFormatter()
        let date = dateFormatter.date(from:dateStr)!
        return date
    }
}
