//
//  XCTestCase+Custom.swift
//  EVIO - WhiteLabel
//
//  Created by João Moreira on 13/07/2023.
//

import XCTest

extension XCTestCase {
    
    func trackForMemoryLeak(instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(
                instance,
                "memory leak on \(String(describing: instance))",
                file: file,
                line: line
            )
        }
    }
    
}
