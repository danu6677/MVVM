//
//  Int+Ext.swift
//  CBC
//
//  Created by Danutha Fernando on 2023-10-01.
//

import Foundation

extension Int {
    func toFormattedDateTime() -> String {
        let timestamp = Double(self) / 1000.0 // Assuming the timestamp is in milliseconds
                let date = Date(timeIntervalSince1970: timestamp)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // You can change the format as needed
                let formattedDate = dateFormatter.string(from: date)
                return formattedDate
    }
    
}
