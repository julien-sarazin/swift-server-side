import PerfectLib
import PerfectHTTP

extension HTTPResponse {
    func json(_ data: JSONConvertible) {
        self.setHeader(.contentType, value: "application/json")

        guard let json = try? data.jsonEncodedString() else {
            self.status = .badRequest
            return self.completed()
        }

        self.setBody(string: json)
        self.completed()
    }

    func status(_ status: HTTPResponseStatus) -> HTTPResponse {
        self.status = status
        return self
    }
}
