//
//  DataType.swift
//  PopulationFetcher
//
//  Created by João Moreira on 16/11/2024.
//

import Foundation

enum DataType: String, CaseIterable, Identifiable {
    // Enum cases representing different data types.
    case nation = "Nation" // Represents national data, with the raw value "Nation".
    case state = "State" // Represents state data, with the raw value "State".
    
    // Conforms to Identifiable to provide a unique identifier for each case.
    var id: String {
        return self.rawValue // Uses the raw value as the unique identifier.
    }
}

