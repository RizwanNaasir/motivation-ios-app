import Foundation
import UIKit
import Toast_Swift

public func requestData<T: Codable>(
        _ url: String,
        method: String = "GET",
        parameters: Dictionary<String, Any>? = nil,
        encoding: String.Encoding = .utf8,
        headers: [String: Any]? = nil,
        completion: @escaping (Response<T>?, Error?) -> Void) {

    var request = URLRequest(url: URL(string: url)!, timeoutInterval: Double.infinity)
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    if let authToken = UserDefaults.standard.string(forKey: "AuthToken") {
        request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
    }
    if let headers = headers {
        for (key, value) in headers {
            request.addValue(value as! String, forHTTPHeaderField: key)
        }
    }
    request.httpMethod = method

    if let parameters = parameters {
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
    }

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(nil, error)
            return
        }

        guard let data = data else {
            completion(nil, nil)
            return
        }

        do {
            let decoder = JSONDecoder()
            let responseData = try decoder.decode(Response<T>.self, from: data)
            enqueueToast(responseData.message)
            completion(responseData, nil)
        } catch {
            completion(nil, error)
        }
    }
    task.resume()
}

public func request(
        _ url: String,
        method: String = "GET",
        parameters: [String: Any]? = nil,
        encoding: String.Encoding = .utf8,
        headers: [String: Any]? = nil,
        completion: @escaping (Error?) -> Void
) {
    var request = URLRequest(url: URL(string: url)!, timeoutInterval: Double.infinity)
    request.addValue("application/json", forHTTPHeaderField: "Accept")

    if let authToken = UserDefaults.standard.string(forKey: "AuthToken") {
        request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
    }

    if let headers = headers {
        for (key, value) in headers {
            request.addValue(value as! String, forHTTPHeaderField: key)
        }
    }

    request.httpMethod = method

    if let parameters = parameters {
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
    }

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(error)
            return
        }
        do {
            let decoder = JSONDecoder()
            let responseData = try decoder.decode(EmptyResponse.self, from: data ?? Data())
            enqueueToast(responseData.message)
            completion(nil)
        } catch {
            completion(error)
        }

    }

    task.resume()
}

public struct Response<T: Codable>: Codable {
    let message: String
    let data: T?
}

public struct EmptyResponse: Codable {
    let message: String
}

public func enqueueToast(_ message: String) {
    DispatchQueue.main.async {
        let scene = UIApplication
                .shared
                .connectedScenes
                .flatMap {
                    ($0 as? UIWindowScene)?.windows ?? []
                }
                .last {
                    $0.isKeyWindow
                }
        scene?.makeToast(message)
    }
}
