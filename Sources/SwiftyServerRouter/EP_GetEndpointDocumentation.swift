// MIT license. Copyright (c) 2018 SwiftyServerRouter. All rights reserved.
import PerfectHTTP
import PerfectMustache

public class EP_GetEndpointDocumentation: Endpoint {
	public required init() {}

	public let purpose = "Documentation for all endpoints"

	public func handler(context: HandlerContext) throws {

		let builder = RouteBuilder_Documentation()
		builder.populate()
		let endpoints: [Any] = builder.items.map { $0.jsonDictionary }

		let endpoint_count = builder.items.count
		let endpoint_count_pretty: String
		if endpoint_count == 1 {
			endpoint_count_pretty = "1 Endpoint"
		} else {
			endpoint_count_pretty = "\(endpoint_count) Endpoints"
		}

		let renderContext: [String : Any] = [
			"endpoint": endpoints,
			"endpoint_count": endpoint_count_pretty
		]
		context.response.render(template: "views/components/document_endpoints", context: renderContext)
	}
	
}

extension EndpointItem {
	fileprivate var jsonDictionary: [String : Any] {
		let security: String
		if insecure_noAuthentication {
			security = "PUBLIC"
		} else {
			security = "-"
		}
		return [
			"security": security,
			"method": self.method,
			"route": self.route,
			"purpose": self.purpose,
			"class": self.className
		]
	}
}

fileprivate struct MustacheHandler: MustachePageHandler {
	var context: [String: Any]
	func extendValuesForResponse(context contxt: MustacheWebEvaluationContext, collector: MustacheEvaluationOutputCollector) {
		contxt.extendValues(with: context)
		do {
			contxt.webResponse.setHeader(.contentType, value: "text/html")
			try contxt.requestCompleted(withCollector: collector)
		} catch {
			let response = contxt.webResponse
			response.status = .internalServerError
			response.appendBody(string: "\(error)")
			response.completed()
		}
	}

	init(context: [String: Any] = [String: Any]()) {
		self.context = context
	}
}

extension HTTPResponse {
	fileprivate func render(template: String, context: [String: Any] = [String: Any]()) {
		mustacheRequest(request: self.request, response: self, handler: MustacheHandler(context: context), templatePath: request.documentRoot + "/\(template).mustache")
	}
}
