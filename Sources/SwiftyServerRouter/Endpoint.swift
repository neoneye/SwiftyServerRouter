// MIT license. Copyright (c) 2018 SwiftyServerRouter. All rights reserved.

protocol Insecure_NoAuthentication {
}


protocol Endpoint: class {
	init()

	var purpose: String { get }

	func handler(context: HandlerContext) throws
}
