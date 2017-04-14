
import PerfectHTTP
import PerfectHTTPServer
import Foundation


class UserController {
	@discardableResult
	static func create(data: [String: Any]) -> User? {
		guard let email = data["email"] as? String else {
			return nil
		}

		guard let password = data["password"] as? String else {
			return nil
		}

		print("birthDate: \(data["birthDate"])")

		guard let birthDate = data["birthDate"] as? Date else {
			return nil
		}

		print("birthDate: \(birthDate)")

		var user = User()
		user.email = email
		user.password = password
		user.birthDate = birthDate
		
		db.append(user)
		return user
	}
}
