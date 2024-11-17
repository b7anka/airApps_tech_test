//
//  MockDataFilter.swift
//  PopulationFetcherTests
//
//  Created by João Moreira on 16/11/2024.
//

import XCTest
@testable import PopulationFetcher

final class MockDataFilter: DataFilterProtocol {
    private let dataType: DataType

    init(dataType: DataType) {
        self.dataType = dataType
    }

    func filter(data: [PopulationInformation], searchText: String) -> [PopulationInformation] {
        if searchText.isEmpty {
            return data
        } else {
            switch dataType {
            case .state:
                return data.filter { info in
                    info.state?.localizedCaseInsensitiveContains(searchText) ?? false
                }
            case .nation:
                return data.filter { info in
                    info.nation?.localizedCaseInsensitiveContains(searchText) ?? false
                }
            }
        }
    }
}
