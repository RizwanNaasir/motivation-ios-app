//
//  LoginView.swift
//  motivation
//
//  Created by InterLink on 6/28/23.
//

import SwiftUI
import ActionButton

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoading: Bool = false
    @State private var showToast: Bool = false
    @State private var isLoggedIn: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("AuthToken") var authToken: String?
    @State var actionButtonState: ActionButtonState =
            .enabled(title: "Login", systemImage: "arrow.right.square")

    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome!")
                        .font(.largeTitle)
                        .padding()
                Form {
                    Section(header: Text("Email")) {
                        CustomTextField(
                                text: $username,
                                placeholder: "john@example.com",
                                keyboardType: .emailAddress,
                                textContentType: .emailAddress
                        )
                    }
                    Section(header: Text("Password")) {
                        SecureField("Password", text: $password)
                    }
                }
                        .shadow(color: colorScheme == .dark ? .white.opacity(0.01) : .black.opacity(0.1), radius: 15, x: 0, y: 5)
                        .padding(.top)
                        .background(colorScheme == .dark ? Color.black : Color.white)
                        .scrollContentBackground(.hidden)

                ActionButton(state: $actionButtonState, onTap: {
                    actionButtonState = .loading(title: "Logging", systemImage: "arrow.right.square")
                    signInWithCred(username: username, password: password) { success in
                        if success {
                            // Sign-in successful
                            isLoggedIn = true
                            actionButtonState = .enabled(title: "Logged In", systemImage: "checkmark")
                        } else {
                            // Sign-in failed
                            actionButtonState = .enabled(title: "Login", systemImage: "arrow.right.square")
                        }
                    }
                }, backgroundColor: Color.blue)
                        .frame(maxWidth: .infinity) // Make the button full width
                        .padding()
                        .cornerRadius(8.0)
                        .shadow(color: colorScheme == .dark ? .white.opacity(0.01) : .black.opacity(0.1), radius: 15, x: 0, y: 5)

                HStack {
                    Text("Don't have an account?")
                            .foregroundColor(.gray)
                    // NavigationLink to RegisterView
                    NavigationLink("Register") {
                        RegisterView()
                    }
                }
                        .padding(.bottom)
            }
                    .padding()
                    .background(
                            NavigationStack {
                                EmptyView() // Add an empty view as a workaround
                                        .navigationDestination(isPresented: $isLoggedIn) {
                                            ContentView()
                                                    .navigationBarBackButtonHidden(true) // Hide the back button in the ContentView
                                        }
                            }
                    )
        }
    }

    private func checkAuthToken() {
        if let authToken = authToken, !authToken.isEmpty {
            // AuthToken available, navigate to ContentView
            navigateToContentView()
        }
    }

    private func navigateToContentView() {
        // Reset the registration form
        username = ""
        password = ""
        isLoggedIn = false
    }
}


//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
