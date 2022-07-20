//
//  Date+Extension.swift
//  Githubber
//
//  Created by Terry Kuo on 2021/5/3.
//

import Foundation

extension Date {
    
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        
        return dateFormatter.string(from: self)
    }
    
    func convertToMonthDayYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        return dateFormatter.string(from: self)
    }
    
    
    //MARK: - new ios 15 formatter
    func convertToMonthYearFormat2() -> String {
        return formatted(.dateTime.month(.wide).year())
    }
}
