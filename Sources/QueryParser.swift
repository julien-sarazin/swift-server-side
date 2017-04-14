//
//  QueryParser.swift
//  Todolist-swift
//
//  Created by Julien Sarazin on 14/04/2017.
//
//

import Foundation

open class QueryParser {

	public static let parse: Middleware = { request, response, info in
		var query = [String: Any]()

		request.queryParams.forEach({ (key, value) in
			query[key] = value
		})

		info["query"] = query
		return false
	}
}
