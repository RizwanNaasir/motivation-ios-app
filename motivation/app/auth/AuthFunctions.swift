import Foundation

func sendRequest(url: String, method: String, parameters: [String: Any]?, completion: @escaping (Bool) -> Void) {
    guard let url = URL(string: url) else {
        completion(false)
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = method

    if let parameters = parameters {
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    }

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error: \(error.localizedDescription)")
            completion(false)
            return
        }

        guard let data = data,
              let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            completion(false)
            return
        }

        // Handle the successful response
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let responseData = json["data"] as? [String: Any],
           let token = responseData["token"] as? String {
            UserDefaults.standard.set(token, forKey: "AuthToken")
            print("Token stored in local storage")
        } else {
            print("Token not found in response")
        }

        completion(true)
    }

    task.resume()
}

func signInWithCred(username: String, password: String, completion: @escaping (Bool) -> Void) {
    print("Attempting sign-in...")

    let params = ["email": username, "password": password]

    sendRequest(url: LOGIN_ROUTE, method: "POST", parameters: params) { success in
        completion(success)
    }
}

func registerWithData(name: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
    print("Attempting sign-up...")

    let params = ["name": name, "email": email, "password": password]

    sendRequest(url: REGISTER_ROUTE, method: "POST", parameters: params) { success in
        completion(success)
    }
}
