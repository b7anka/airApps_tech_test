//
//  PopulationInformation.swift
//  PopulationFetcher
//
//  Created by João Moreira on 16/11/2024.
//

import Foundation

struct PopulationInformation: Codable, Identifiable, Equatable {
    
    // Unique identifier for each instance, assigned automatically.
    let id: UUID = UUID()
    
    // Properties representing different pieces of population information, matching the JSON structure.
    let nationID: String? // Optional identifier for the nation.
    let stateID: String? // Optional identifier for the state.
    let nation: String? // Optional name of the nation.
    let state: String? // Optional name of the state.
    let year: String? // Optional year of the population data.
    let population: UInt? // Optional population count, stored as an unsigned integer.
    
    // Enum defining custom keys for decoding and encoding to match the JSON field names.
    enum CodingKeys: String, CodingKey {
        case nationID = "ID Nation" // Maps "ID Nation" in JSON to `nationID`.
        case stateID = "ID State" // Maps "ID State" in JSON to `stateID`.
        case nation = "Nation" // Maps "Nation" in JSON to `nation`.
        case state = "State" // Maps "State" in JSON to `state`.
        case year = "Year" // Maps "Year" in JSON to `year`.
        case population = "Population" // Maps "Population" in JSON to `population`.
    }
}

