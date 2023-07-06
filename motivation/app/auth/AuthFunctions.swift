import Foundation

func signInWithCred(username: String, password: String, completion: @escaping (Bool) -> Void) {
    print("Attempting sign-in...")

    let params = ["email": username, "password": password]
    requestData(LOGIN_ROUTE, method: "POST", parameters: params) { (response: Response<ResponseContainingToken>?, error) in
        if error != nil {
            completion(false)
            return
        }
        if ((response?.data?.token) != nil) {
            let token = response?.data?.token
            UserDefaults.standard.set(token, forKey: "AuthToken")
            completion(true)
        } else {
            completion(false)
        }
    }
}

func registerWithData(name: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
    print("Attempting sign-up...")

    let params = ["name": name, "email": email, "password": password]

    requestData(REGISTER_ROUTE, method: "POST", parameters: params) { (response: Response<ResponseContainingToken>?, error) in
        if error != nil {
            completion(false)
            return
        }
        if ((response?.data?.token) != nil) {
            let token = response?.data?.token
            UserDefaults.standard.set(token, forKey: "AuthToken")
            completion(true)
        } else {
            completion(false)
        }
    }
}

struct ResponseContainingToken: Codable {
    let token: String
}
