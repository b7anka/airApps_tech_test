//
//  NetworkServiceProtocol.swift
//  PopulationFetcher
//
//  Created by João Moreira on 16/11/2024.
//

import Foundation

protocol NetworkServiceProtocol: AnyObject {
    // Asynchronous method that fetches population data based on the specified data type.
    // Throws an error if the request fails, and returns an array of PopulationInformation.
    func fetchPopulationData(type: DataType) async throws -> [PopulationInformation]
}
