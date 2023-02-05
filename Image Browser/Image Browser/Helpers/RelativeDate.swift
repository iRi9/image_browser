//
//  RelativeDate.swift
//  Image Browser
//
//  Created by Giri Bahari on 05/02/23.
//

import Foundation

class RelativeDate {

    static func string(for date: Date) -> String {

        let calendar = Calendar.current
        let now = Date()

        let dateComponents = calendar.dateComponents([.day, .month, .year], from: date, to: now)

        switch (dateComponents.day, dateComponents.month, dateComponents.year) {
        case (0, _, _):
            return "now"
        case (1, _, _):
            return "yesterday"
        default:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy"
            return dateFormatter.string(from: date)
        }
    }
}
