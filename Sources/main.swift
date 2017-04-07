import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import Foundation

let api = HTTPServer()
var routes = Routes()

var db: [User] = [User]()

routes.add(method: .post, uri: "/users") { request, response in
	guard let name: String = request.body?["name"] as? String else {
		return response
			.status(.badRequest)
			.completed()
	}

	let user = User(name: name)
	db.append(user)

	response.json(user)
}

routes.add(method: .get, uri: "/users") { request, response in
	return response.json(db)
}

routes.add(method: .get, uri: "/users/{id}") { request, response in
	let identifier = request.urlVariables["id"]
	for user in db {
		if user.id == identifier {
			return response.json(user)
		}
	}

	return response
		.status(.notFound)
		.json([
			"error": "user.not.found"
			])
}

routes.add(method: .delete, uri: "/users/{id}") { request, response in
	let identifier = request.urlVariables["id"]

	guard let index = db.index(where: { (user) -> Bool in
		return user.id == identifier
	}) else {
		return response
			.status(.notFound)
			.completed()
	}


	db.remove(at: index)
	return response
		.status(.noContent)
		.completed()
}

routes.add(method: .put, uri: "/users/{id}") { request, response in
	let identifier = request.urlVariables["id"]

	guard let name = request.body?["name"] as? String else {
		return response
			.status(.badRequest)
			.completed()
	}

	for var user in db {
		if user.id == identifier {
			user.name = name
			return response
				.status(.noContent)
				.completed()
		}
	}

	return response
		.status(.notFound)
		.completed()
}
api.addRoutes(routes)
api.serverPort = 8080

do {
	try api.start()
	print("Server listening on port \(api.serverPort)")
} catch PerfectError.networkError(let err, let msg) {
	print("Network error thrown: \(err) \(msg)")
}
