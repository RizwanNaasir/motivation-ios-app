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
        VStack {
            Image("Banner")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .padding()
                    .cornerRadius(8.0)
                    .padding(.bottom, 32.0)
            // Replace with your logo image

            CustomTextField(
                    text: $username,
                    placeholder: "Username",
                    keyboardType: .emailAddress,
                    textContentType: .emailAddress
            )

            SecureField("Password", text: $password)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    .padding(.horizontal)

            Spacer().padding(1)

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

            Spacer().padding(2)

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
