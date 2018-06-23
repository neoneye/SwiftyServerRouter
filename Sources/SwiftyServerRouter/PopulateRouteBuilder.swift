// MIT license. Copyright (c) 2018 SwiftyServerRouter. All rights reserved.
import PerfectHTTP

public class PopulateRouteBuilder {
	public typealias Populate = (_ routeBuilder: RouteBuilder) -> Void
	public static var populate: Populate?
}

extension RouteBuilder {
	public func populate() {
		PopulateRouteBuilder.populate?(self)
	}
}
