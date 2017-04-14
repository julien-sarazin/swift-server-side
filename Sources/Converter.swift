//
//  Transformer.swift
//  Todolist-swift
//
//  Created by Julien Sarazin on 14/04/2017.
//
//

import Foundation

typealias Transformer = (Any) -> Any?


class Converter {
	static let toDate =  { (param: Any) -> Date? in
		if let number = param as? TimeInterval {
			let d = Date(timeIntervalSince1970: number)
			return d
		}

		return nil
	}

	static func body(fields: [String: Transformer]) -> Middleware {

		return { request, response, info in
			guard var body = info["body"] as? [String: Any] else {
				return true
			}

			for (field, transformer) in fields {
				if let param = body[field] {
					body[field] = transformer(param)
				}
			}

			info["body"] = body

			return false
		}
	}
}
