import PerfectLib
import StORM
import MongoDBStORM

class User: MongoDBStORM {
    var id: String          = ""
    var email: String       = ""
    var password: String    = ""
    var firstname: String   = ""
    var lastname: String    = ""

    override init() {
        super.init()
        self._collection = "users"
    }

    // The mapping that translates the database info back to the object
    // This is where you would do any validation or transformation as needed
    override func to(_ this: StORMRow) {
        self.id = this.data["_id"] as? String ?? ""
        self.firstname = this.data["firstname"] as? String ?? ""
        self.lastname = this.data["lastname"] as? String ?? ""
        self.email = this.data["email"] as? String ?? ""
    }

    // A simple iteration.
    // Unfortunately necessary due to Swift's introspection limitations
    func rows() -> [User] {
        var rows = [User]()
        for i in 0..<self.results.rows.count {
            let row = User()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
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
                "email": self.email
        ]
    }

    /// Encode the object into JSON text
    public func jsonEncodedString() throws -> String {
        return try self.getJSONValues().jsonEncodedString()
    }
}

extension User: Repository {
    typealias ModelType = User

    final func find(criteria: [String: Any]?, completion: (Result<[User]>) -> (Void)) {
        let result = Result<[User]>()
        let criteria = criteria ?? [String: Any]()

        do {
            result.data = try User().find(criteria) as? [User]
        }
        catch {
            result.error = error
        }

        completion(result)
    }

    final func findOne(criteria: [String: Any]?, completion: (Result<User>) -> (Void)) {
        let result = Result<User>()
        let criteria = [String: Any]()

        do {
            let users = User()
            try users.find(criteria)
            users.results
            result.data = users.first
        } catch {
            result.error = error
        }

        completion(result)
    }

    final func store(models: [User], completion: (Result<[User]>) -> (Void)) {
        let result = Result<[User]>()

        do {
            var data = [User]()
            for let user in models {
                try user.save()
                data.append(user)
            }
            result.data = data
        } catch {
            result.error = error
        }

        completion(result)
    }

    final func storeOne(model: User, completion: (Result<User>) -> (Void)) {
        let result = Result<User>()

        do {
            try model.save()
            result.data = model
        }
        catch {
            result.error = error
        }

        completion(result)
    }

    final func update(models: [User], completion: (Result<[User]>) -> (Void)) {
        let result = Result<[User]>()

        do {
            var data: [User] = [User]()

            for let user in models {
                try user.save()
                data.append(user)
            }
            result.data = data
        }
        catch {
            result.error = error
        }

        completion(result)
    }

    final func updateOne(model: User, completion: (Result<User>) -> (Void)) {
        let result = Result<User>()

        do {
            try model.save()
            result.data = model
        }
        catch {
            result.error = error
        }

        completion(result)
    }

    final func remove(models: [User], completion: (Result<[User]?>) -> (Void)) {
        let result = Result<[User]?>()
        do {
           for let user in models {
               try user.delete()
           }
        }
        catch {
            result.error = error
        }

        completion(result)
    }
}
