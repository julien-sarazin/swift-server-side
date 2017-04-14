//
//  DGMiddleware.swift
//  Todolist-swift
//
//  Created by Julien Sarazin on 14/04/2017.
//
//

import PerfectLib
import PerfectHTTP

public typealias Middleware = (HTTPRequest, HTTPResponse, inout [String: Any]) -> (Bool)

open class MiddlewareHandler {
	static func all(_ middlewares: [Middleware]) -> RequestHandler {
		return { request, response in
			var info = [String: Any]()
			for middleware in middlewares {
				if middleware(request, response, &info) {
					return
				}
			}
		}
	}
}

