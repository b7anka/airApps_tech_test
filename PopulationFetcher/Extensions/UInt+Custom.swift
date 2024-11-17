//
//  Int+Custom.swift
//  PopulationFetcher
//
//  Created by João Moreira on 16/11/2024.
//

import Foundation

extension UInt {
    // Computed property that formats the integer with thousands separators.
    var formattedWithSeparator: String {
        // Uses a custom NumberFormatter to insert separators in the numeric string.
        Formatter.withSeparator.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
