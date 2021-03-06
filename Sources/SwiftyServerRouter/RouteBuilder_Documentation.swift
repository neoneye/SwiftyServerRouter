// MIT license. Copyright (c) 2018 SwiftyServerRouter. All rights reserved.
import PerfectHTTP

public class RouteBuilder_Documentation: RouteBuilder {
	private var stack = [String]()
	public var items = [EndpointItem]()

	public init() {}

	public func scope(_ item: String, scopeInner: () -> Void) {
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

	public func endpoint<T: Endpoint>(method: Endpoint_HTTPMethod, route: String, handlerType: T.Type) {
		let uri: String = stack.joined() + route
		let className = String(describing: handlerType)
		let handler: Endpoint = handlerType.init()
		let purpose: String = handler.purpose
		let insecure_noAuthentication: Bool = handler is Insecure_NoAuthentication
		let item = EndpointItem(
			method: String(describing: method).lowercased(),
			route: uri,
			purpose: purpose,
			insecure_noAuthentication: insecure_noAuthentication,
			className: className
		)
		self.items.append(item)
	}

	public func perfect_endpoint(method: PerfectHTTP.HTTPMethod, route: String, purpose: String, data: [String:Any], handler: @escaping Perfect_ReturnsRequestHandlerGivenData) {
		let uri: String = stack.joined() + route

		let item = EndpointItem(
			method: String(describing: method).lowercased(),
			route: uri,
			purpose: purpose,
			insecure_noAuthentication: true,
			className: "simple"
		)
		self.items.append(item)
	}
}

public class EndpointItem {
	public let method: String
	public let route: String
	public let purpose: String
	public let insecure_noAuthentication: Bool
	public let className: String

	public init(method: String, route: String, purpose: String, insecure_noAuthentication: Bool, className: String) {
		self.method = method
		self.route = route
		self.purpose = purpose
		self.insecure_noAuthentication = insecure_noAuthentication
		self.className = className
	}
}
