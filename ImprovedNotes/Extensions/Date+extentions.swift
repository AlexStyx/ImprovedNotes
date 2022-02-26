//
//  Date+extentions.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 2/20/22.
//

import Foundation


extension Date {
    func dateString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: self).replacingOccurrences(of: "/", with: ".")
    }
}
