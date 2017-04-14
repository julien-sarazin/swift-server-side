import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import Foundation

let api = HTTPServer()
var db: [User] = [User]()
var routes = Routes()

routes.add(method: .post, uri: "/users", handler: MiddlewareHandler.all([
	BodyParser.parse,
	QueryParser.parse,
	Converter.body(fields: ["birthDate": Converter.toDate]),
	Validator.body(
		required: [
			"password": [
				StringRules.minLength(10)
			]
		],
		optional: [
			"password": [
				StringRules.minLength(10)
			]
		]),
	UserAction.create
	]))


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

	guard let name = request.body?["firstname"] as? String else {
		return response
			.status(.badRequest)
			.completed()
	}

	for var user in db {
		if user.id == identifier {
			user.firstname = name
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
