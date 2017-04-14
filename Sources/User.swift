import PerfectLib
import Foundation

struct User {
    var id: String          = ""
    var email: String		= ""
    var password: String	= ""
	var birthDate: Date?
    var firstname: String?
    var lastname: String?
}

extension User: JSONConvertible {
    mutating func setJSONValues(_ values: [String: Any]) {
        self.id             = values["id"] as? String ?? ""
        self.firstname      = values["firstname"] as? String ?? ""
        self.lastname       = values["lastname"] as? String ?? ""
        self.email          = values["email"] as? String ?? ""
        self.password       = values["password"] as? String ?? ""
    }

    /// Set the object properties based on the JSON keys/values.
    func getJSONValues() -> [String: Any] {
        return [
                "id": self.id,
                "firstname": self.firstname,
                "lastname": self.lastname,
                "birthDate" : self.birthDate?.description,
                "email": self.email
        ]
    }

    /// Encode the object into JSON text
    public func jsonEncodedString() throws -> String {
        return try self.getJSONValues().jsonEncodedString()
    }
}
