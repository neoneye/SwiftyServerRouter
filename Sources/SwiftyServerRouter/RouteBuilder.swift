// MIT license. Copyright (c) 2018 SwiftyServerRouter. All rights reserved.
#if canImport(PerfectHTTP)
import PerfectHTTP
#endif

#if canImport(PerfectHTTP)
	/// Corresponds to the private typealias found in the PerfectHTTPServer package "HTTPServerExConfig.swift" file
	typealias Perfect_ReturnsRequestHandlerGivenData = ([String:Any]) throws -> RequestHandler
#endif


#if canImport(PerfectHTTP)

typealias Endpoint_HTTPMethod = PerfectHTTP.HTTPMethod

#else

enum Endpoint_HTTPMethod {
	case get, post, put, delete
}

#endif


protocol RouteBuilder {
	func scope(_ item: String, scopeInner: () -> Void)
	
	func endpoint<T: Endpoint>(method: Endpoint_HTTPMethod, route: String, handlerType: T.Type)

	#if canImport(PerfectHTTP)
	func perfect_endpoint(method: PerfectHTTP.HTTPMethod, route: String, purpose: String, data: [String:Any], handler: @escaping Perfect_ReturnsRequestHandlerGivenData)
	#endif
}

extension RouteBuilder {
	func get<T: Endpoint>(_ route: String, _ handlerType: T.Type) {
		endpoint(method: .get, route: route, handlerType: handlerType)
	}

	func post<T: Endpoint>(_ route: String, _ handlerType: T.Type) {
		endpoint(method: .post, route: route, handlerType: handlerType)
	}

	func put<T: Endpoint>(_ route: String, _ handlerType: T.Type) {
		endpoint(method: .put, route: route, handlerType: handlerType)
	}

	func delete<T: Endpoint>(_ route: String, _ handlerType: T.Type) {
		endpoint(method: .delete, route: route, handlerType: handlerType)
	}

	#if canImport(PerfectHTTP)
	func perfect_get(_ route: String, _ purpose: String, _ handler: @escaping Perfect_ReturnsRequestHandlerGivenData) {
		perfect_endpoint(method: .get, route: route, purpose: purpose, data: [:], handler: handler)
	}

	func perfect_post(_ route: String, _ purpose: String, _ handler: @escaping Perfect_ReturnsRequestHandlerGivenData) {
		perfect_endpoint(method: .post, route: route, purpose: purpose, data: [:], handler: handler)
	}
	#endif
}
