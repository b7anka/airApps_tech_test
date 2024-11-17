//
//  DetailsViewModel.swift
//  PopulationFetcher
//
//  Created by João Moreira on 16/11/2024.
//

import Foundation

final class DetailsViewModel: ObservableObject {
    
    // Published properties that notify observers of changes, allowing the SwiftUI view to reactively update.
    @Published var title: String // Title to display, based on the data type (e.g., state or nation).
    @Published var id: String // ID to display, also based on the data type.
    @Published var year: String // The year associated with the population data.
    @Published var population: String // Population number formatted as a string with separators.
    
    // Additional info as an array of key-value pairs, allowing the view to display dynamic information.
    var additionalInfo: [(title: String, value: String)] = []
    
    // Initializer receives data and determines display content based on the data type (state or nation).
    init(data: PopulationInformation, type: DataType) {
        // Sets title and id based on whether the type is state or nation.
        if type == .state {
            self.title = data.state ?? "Unknown State" // Sets the title to state name or default.
            self.id = data.stateID ?? "Unknown ID" // Sets the ID to state ID or default.
        } else {
            self.title = data.nation ?? "Unknown Nation" // Sets the title to nation name or default.
            self.id = data.nationID ?? "Unknown ID" // Sets the ID to nation ID or default.
        }
        
        // Sets the year, defaulting to "Unknown Year" if not available.
        self.year = data.year ?? "Unknown Year"
        
        // Sets the population, using a formatted string with separators; defaults to "Unknown Population".
        self.population = data.population?.formattedWithSeparator ?? "Unknown Population"
        
        // Adds additional information to display conditionally, based on available data fields.
        if let nation = data.nation {
            additionalInfo.append((title: "Nation", value: nation)) // Adds nation if present.
        }
        if let state = data.state {
            additionalInfo.append((title: "State", value: state)) // Adds state if present.
        }
    }
    
}

