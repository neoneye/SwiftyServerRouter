// MIT license. Copyright (c) 2018 SwiftyServerRouter. All rights reserved.
#if canImport(PerfectHTTP)
import PerfectHTTP


class RouteBuilder_PerfectRoutes: RouteBuilder {
	private var stack = [String]()
	var routes = PerfectHTTP.Routes()

	func scope(_ item: String, scopeInner: () -> Void) {
		push(item)
		scopeInner()
		pop()
	}

	private func push(_ item: String) {
		stack.append(item)
	}

	private func pop() {
		guard stack.popLast() != nil else {
			fatalError("Expected same number of push and pops, but more pop()s are invoked")
		}
	}

	func endpoint<T: Endpoint>(method: Endpoint_HTTPMethod, route: String, handlerType: T.Type) {
		let uri: String = stack.joined() + route
		let perfectHandler = exceptionHandler() { (request: HTTPRequest, response: HTTPResponse) in
			let context = HandlerContext(request: request, response: response)
			let handler: Endpoint = handlerType.init()
			try handler.handler(context: context)
		}
		routes.add(method: method, uri: uri, handler: perfectHandler)
	}

	func perfect_endpoint(method: PerfectHTTP.HTTPMethod, route: String, purpose: String, data: [String:Any], handler: @escaping Perfect_ReturnsRequestHandlerGivenData) {
		let uri: String = stack.joined() + route
		guard let resolvedHandler = try? handler(data) else {
			log.error("endpoint did not return a handler")
			return
		}
		routes.add(method: method, uri: uri, handler: resolvedHandler)
	}
}


/// Build a dictionary for use with `HTTPServerExConfig.swift`
/// That is initialized like this: `try HTTPServer.launch(configurationData: confData)`
class RouteBuilder_PerfectDictionary: RouteBuilder {
	private var stack = [String]()
	var routes = [[String: Any]]()

	func scope(_ item: String, scopeInner: () -> Void) {
		push(item)
		scopeInner()
		pop()
	}

	private func push(_ item: String) {
		stack.append(item)
	}

	private func pop() {
		guard stack.popLast() != nil else {
			fatalError("Expected same number of push and pops, but more pop()s are invoked")
		}
	}

	func endpoint<T: Endpoint>(method: Endpoint_HTTPMethod, route: String, handlerType: T.Type) {
		let uri: String = stack.joined() + route
		let perfectHandler = exceptionHandler() { (request: HTTPRequest, response: HTTPResponse) in
			let context = HandlerContext(request: request, response: response)
			let handler: Endpoint = handlerType.init()
			try handler.handler(context: context)
		}
		let methodName = method.description.lowercased()
		routes.append(["method":methodName, "uri":uri, "handler":perfectHandler])
	}

	func perfect_endpoint(method: PerfectHTTP.HTTPMethod, route: String, purpose: String, data: [String:Any], handler: @escaping Perfect_ReturnsRequestHandlerGivenData) {
		let uri: String = stack.joined() + route
		let methodName = method.description.lowercased()
		var data2 = data
		data2["method"] = methodName
		data2["uri"] = uri
		data2["handler"] = handler
		routes.append(data2)
	}
}

fileprivate typealias ThrowingRequestHandler = (HTTPRequest, HTTPResponse) throws -> ()

fileprivate func exceptionHandler(_ handler: @escaping ThrowingRequestHandler) -> RequestHandler {
	let result: (HTTPRequest, HTTPResponse) -> () = { (request, response) in
		do {
			try handler(request, response)
		} catch let EndpointHandlerError.custom(message, status) {
			var dict = [String: Any]()
			dict["uri"] = request.uri
			dict["status"] = status.code
			dict["description"] = status.description
			dict["message"] = message
			let jsonString: String? = try? dict.jsonEncodedString()
			response.status = status
			response.setHeader(.contentType, value: "application/json")
			response.setBody(string: jsonString ?? "{}")
			response.completed()
		} catch {
			var dict = [String: Any]()
			dict["uri"] = request.uri
			dict["status"] = 500
			dict["message"] = "Unhandled exception: \(error)"
			let jsonString: String? = try? dict.jsonEncodedString()
			response.status = .internalServerError
			response.setHeader(.contentType, value: "application/json")
			response.setBody(string: jsonString ?? "{}")
			response.completed()
		}
	}
	return result
}

#endif
