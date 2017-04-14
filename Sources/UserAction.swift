//
//  UserAction.swift
//  Todolist-swift
//
//  Created by Julien Sarazin on 14/04/2017.
//
//

class UserAction {
	static let create: Middleware = { request, response, info in

		guard let data = info["body"] as? [String: Any] else {
			response
				.status(.badRequest)
				.completed()
			return true
		}

		UserController.create(data: data)
		response.status(.created).completed()
		return true
	}
}
