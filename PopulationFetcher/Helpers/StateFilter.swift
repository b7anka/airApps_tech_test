//
//  StateFilter.swift
//  PopulationFetcher
//
//  Created by João Moreira on 17/11/2024.
//

import Foundation

final class StateFilter: DataFilterProtocol {
    
    // Filters an array of PopulationInformation based on the provided search text.
    func filter(data: [PopulationInformation], searchText: String) -> [PopulationInformation] {
        // If searchText is empty, return the unfiltered data.
        if searchText.isEmpty {
            return data
        } else {
            // If searchText is not empty, filter the data to include only entries
            // where the state name contains the search text (case insensitive).
            return data.filter { info in
                info.state?.localizedCaseInsensitiveContains(searchText) ?? false
            }
        }
    }
    
}

