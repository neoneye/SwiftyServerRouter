// MIT license. Copyright (c) 2018 SwiftyServerRouter. All rights reserved.
import XCTest
@testable import SwiftyServerRouter


final class SwiftyServerRouterTests: XCTestCase {
    func testExample() {
		let builder = RouteBuilder_Documentation()
		builder.test_simpleRoutes()
		XCTAssertEqual(3, builder.items.count)

		let routes: String = builder.items.map { $0.route }.joined(separator: " ")
		XCTAssertEqual("/v1/save /v1/uptime /ping", routes)

		let classNames: String = builder.items.map { $0.className }.joined(separator: " ")
		XCTAssertEqual("EP_PostSave EP_GetUptime EP_GetPing", classNames)
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}


fileprivate extension RouteBuilder {
	func test_simpleRoutes() {
		scope("/v1") {
			post("/save", EP_PostSave.self)
			get("/uptime", EP_GetUptime.self)
		}
		get("/ping", EP_GetPing.self)
	}
}


fileprivate class EP_PostSave: Endpoint {
	required init() {}

	let purpose = "Save data"

	func handler(context: HandlerContext) throws {
		// do nothing
	}
}


fileprivate class EP_GetUptime: Endpoint {
	required init() {}

	let purpose = "Seconds that the server has been running"

	func handler(context: HandlerContext) throws {
		// do nothing
	}
}


fileprivate class EP_GetPing: Endpoint {
	required init() {}

	let purpose = "Is the server running"

	func handler(context: HandlerContext) throws {
		// do nothing
	}
}
