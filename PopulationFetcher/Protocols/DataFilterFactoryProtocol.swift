//
//  DataFilterFactoryProtocol.swift
//  PopulationFetcher
//
//  Created by João Moreira on 17/11/2024.
//

import Foundation

protocol DataFilterFactoryProtocol: AnyObject {
    // Factory method to create and return a DataFilterProtocol implementation based on the given data type.
    func createFilter(for dataType: DataType) -> DataFilterProtocol
}
