import PerfectLib
import PerfectHTTP
import PerfectHTTPServer


let server = HTTPServer()
var routes = Routes()

routes.add(method: .get, uri: "/") { request, response in
  response.setHeader(.contentType, value: "application/json")
  response.appendBody(string: "{\"hello\": \"world\"}")
  response.completed()
}



server.addRoutes(routes)


server.serverPort = 3000

do {
  try server.start()
  print("Server listening on port \(server.serverPort)")
} catch PerfectError.networkError(let err, let msg) {
  print("Network error thrown: \(err) \(msg)")
}
