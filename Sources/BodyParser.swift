//
//  BodyParser.swift
//  Todolist-swift
//
//  Created by Julien Sarazin on 14/04/2017.
//
//

import Foundation
import PerfectHTTP
import PerfectNet

open class BodyParser {

	private init() {}

	public static let parse: Middleware = { request, response, info in

		guard let contentType = request.header(.contentType) else {
			response.status(.badRequest).completed()
			return true
		}

		if contentType == "application/json" {
			return BodyParser.json(request, response, &info)
		} else if contentType == "application/x-www-form-urlencoded" {
			return BodyParser.urlEncoded(request, response, &info)
		}

		response.status(.badRequest).completed()
		return true
	}

	public static let urlEncoded: Middleware = { request, response, info in
		var body = [String: Any]()

		request.postParams.forEach({ (key, value) in
			body[key] = value
		})

		info["body"] = body
		return false
	}

	public static let json: Middleware = { request, response, info in

		guard let data = request.postBodyString?.data(using: .utf8) else {
			response.status(.badRequest).completed()
			return true
		}

		guard let json = try? JSONSerialization.jsonObject(with: data) else {
			response.status(.badRequest).completed()
			return true
		}

		info["body"] = json
		return false
	}
}


