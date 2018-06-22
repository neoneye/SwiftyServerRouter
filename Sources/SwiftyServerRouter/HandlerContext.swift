// MIT license. Copyright (c) 2018 SwiftyServerRouter. All rights reserved.
import PerfectHTTP

public class HandlerContext {
	public let request: HTTPRequest
	public let response: HTTPResponse

	public init(request: HTTPRequest, response: HTTPResponse) {
		self.request = request
		self.response = response
	}
}
