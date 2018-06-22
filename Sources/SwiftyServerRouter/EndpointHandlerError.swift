// MIT license. Copyright (c) 2018 SwiftyServerRouter. All rights reserved.
import PerfectHTTP

public enum EndpointHandlerError: Error {
	case custom(String, PerfectHTTP.HTTPResponseStatus)
}
