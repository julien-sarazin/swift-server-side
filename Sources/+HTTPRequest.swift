import Foundation
import PerfectHTTP

extension HTTPRequest {
	var body: [String:Any]? {
        guard let data = self.postBodyString?.data(using: .utf8) else {
            return nil
        }

        guard let json = try? JSONSerialization.jsonObject(with: data) else {
            return nil
        }

		return json as? [String: Any]
    }
}
