import SwiftUI

struct RegisterView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading: Bool = false
    @State private var showToast: Bool = false
    @SceneStorage("isRegistered") private var isRegistered: Bool = false

    @AppStorage("AuthToken") var authToken: String?

    var body: some View {
        VStack {
            Text("Register")
                    .font(.largeTitle)
                    .padding()

            TextField("Name", text: $name)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    .padding(.horizontal)

            TextField("Email", text: $email)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    .padding(.horizontal)

            SecureField("Password", text: $password)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    .padding(.horizontal)

            Button(action: {
                isLoading = true
                showToast = true
                registerWithData(
                        name: name,
                        email: email,
                        password: password
                ) { success in
                    if success {
                        // Registration successful
                        isLoading = false
                        isRegistered = true
                    } else {
                        // Registration failed
                        isLoading = false
                    }
                }
            }) {
                if isLoading {
                    ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8.0)
                            .disabled(true)
                } else {
                    Text("Register")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8.0)
                }
            }
                    .padding(.horizontal);
            Spacer()
        }
                .padding()
                .background(
                        NavigationStack {
                            Text("") // Add an empty view as a workaround
                                    .navigationDestination(isPresented: $isRegistered) {
                                        ContentView()
                                                .navigationBarBackButtonHidden(true) // Hide the back button in the ContentView
                                    }
                        }
                )

    }

    private func checkAuthToken() {
        if let authToken = authToken, !authToken.isEmpty {
            // AuthToken available, navigate to ContentView
            navigateToContentView()
        }
    }

    private func navigateToContentView() {
        // Reset the registration form
        name = ""
        email = ""
        password = ""
        isRegistered = false
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
