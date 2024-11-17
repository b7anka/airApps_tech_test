//
//  DefaultDataFilterFactory.swift
//  PopulationFetcher
//
//  Created by João Moreira on 17/11/2024.
//

import Foundation

final class DefaultDataFilterFactory: DataFilterFactoryProtocol {
    
    // Creates and returns the appropriate DataFilterProtocol implementation based on the given data type.
    func createFilter(for dataType: DataType) -> DataFilterProtocol {
        // Uses a switch statement to determine the filter type.
        switch dataType {
        case .state:
            return StateFilter() // Returns a StateFilter if dataType is .state.
        case .nation:
            return NationFilter() // Returns a NationFilter if dataType is .nation.
        }
    }
    
}

