// MIT license. Copyright (c) 2018 SwiftyServerRouter. All rights reserved.
import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(SwiftyServerRouterTests.allTests),
    ]
}
#endif