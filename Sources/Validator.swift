//
//  DGValidator.swift
//  Todolist-swift
//
//  Created by Julien Sarazin on 14/04/2017.
//
//

import PerfectHTTP

public typealias Rule = (Any?) -> (Bool)

open class StringRules {

	public static func minLength(_ length: Int) -> Rule {
		return { value in
			guard let v = value as? String else {
				return false
			}
			return v.characters.count >= length
		}
	}

}

class Validator {

	static func body(required: [String: [Rule]]? = nil, optional: [String: [Rule]]? = nil) -> Middleware {
		return { request, response, info in
			guard let body = info["body"] as? [String: Any] else {
				response.status(.badRequest).completed()
				return true
			}


			if required != nil {
				for (field, rules) in required! {
					guard let param = body[field] else {
						response.status(.badRequest).completed();
						return true
					}

					for rule in rules {
						guard rule(param) else {
							response.status(.badRequest).completed();
							return true
						}
					}
				}
			}

			if optional != nil {
				for (field, rules) in optional! {
					if let param = body[field] {
						for rule in rules {
							guard rule(param) else {
								response.status(.badRequest).completed();
								return true
							}
						}
					}
				}
			}
			return false
		}
	}

	static func validate(fields: [String]) -> Middleware {
		return { request, response, info in
			guard let body = info["body"] as? [String: Any] else {
				response.status(.badRequest).completed()
				return true
			}
			var missings: [String] = [String]();
			for field in fields {
				if body[field] == nil {
					missings.append(field)
				}
			}

			if missings.count > 0 {
				response.status(.badRequest).json(missings)
				return true
			}

			return false
		}
	}
}
