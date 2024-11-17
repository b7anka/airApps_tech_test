//
//  Formatter+Custom.swift
//  PopulationFetcher
//
//  Created by João Moreira on 16/11/2024.
//

import Foundation

extension Formatter {
    // A static, reusable NumberFormatter instance that formats numbers with thousands separators.
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal // Sets the formatter to use decimal style, which includes grouping separators.
        formatter.groupingSeparator = "," // Specifies the grouping separator as a comma.
        return formatter
    }()
}
