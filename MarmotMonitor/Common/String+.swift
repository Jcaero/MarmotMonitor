//
//  String+.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 26/11/2023.
//

import Foundation

extension String {

    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.date(from: self)
    }

    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.dropFirst()
    }
}
