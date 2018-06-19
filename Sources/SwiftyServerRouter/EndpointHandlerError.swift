// MIT license. Copyright (c) 2018 SwiftyServerRouter. All rights reserved.
#if canImport(PerfectHTTP)
import PerfectHTTP
#endif

enum EndpointHandlerError: Error {
	#if canImport(PerfectHTTP)
	case custom(String, PerfectHTTP.HTTPResponseStatus)
	#endif
}
