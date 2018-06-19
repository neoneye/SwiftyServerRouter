// MIT license. Copyright (c) 2018 SwiftyServerRouter. All rights reserved.
#if canImport(PerfectHTTP)
import PerfectHTTP
#endif


#if canImport(PerfectHTTP)

class HandlerContext {
	let request: HTTPRequest
	let response: HTTPResponse

	init(request: HTTPRequest, response: HTTPResponse) {
		self.request = request
		self.response = response
	}
}

#else

class HandlerContext {
	init() {
	}
}

#endif
