//
//  DataFilterProtocol.swift
//  PopulationFetcher
//
//  Created by João Moreira on 17/11/2024.
//

import Foundation

protocol DataFilterProtocol: AnyObject {
    // Defines a method to filter an array of PopulationInformation based on the provided search text.
    func filter(data: [PopulationInformation], searchText: String) -> [PopulationInformation]
}
