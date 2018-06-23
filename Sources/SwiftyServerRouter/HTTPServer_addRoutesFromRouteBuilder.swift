// MIT license. Copyright (c) 2018 SwiftyServerRouter. All rights reserved.
import PerfectHTTPServer

extension HTTPServer {
	public func addRoutesFromRouteBuilder() {
		let builder = RouteBuilder_PerfectRoutes()
		builder.populate()
		addRoutes(builder.routes)
	}
}
