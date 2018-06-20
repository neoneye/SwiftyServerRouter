// MIT license. Copyright (c) 2018 SwiftyServerRouter. All rights reserved.
#if canImport(PerfectHTTP)
import PerfectHTTP
#endif


#if canImport(PerfectHTTP)

public class HandlerContext {
	public let request: HTTPRequest
	public let response: HTTPResponse

	public init(request: HTTPRequest, response: HTTPResponse) {
		self.request = request
		self.response = response
	}
}

#else

public class HandlerContext {
	public init() {
	}
}

#endif
