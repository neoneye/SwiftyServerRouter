// MIT license. Copyright (c) 2018 SwiftyServerRouter. All rights reserved.

public protocol Insecure_NoAuthentication {
}


public protocol Endpoint: class {
	init()

	var purpose: String { get }

	func handler(context: HandlerContext) throws
}
