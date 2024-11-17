//
//  PopulationData.swift
//  PopulationFetcher
//
//  Created by João Moreira on 16/11/2024.
//

import Foundation

struct PopulationData: Codable {
    // An optional array of PopulationInformation objects, representing the main data payload.
    let data: [PopulationInformation]?
}

