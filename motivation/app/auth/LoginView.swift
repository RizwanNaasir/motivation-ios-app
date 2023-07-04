//
//  LoginView.swift
//  motivation
//
//  Created by InterLink on 6/28/23.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var rememberMe: Bool = false
    @State private var isLoading: Bool = false
    @State private var showToast: Bool = false
    @State private var isLoggedIn: Bool = false

    @AppStorage("AuthToken") var authToken: String?

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

            TextField("Username", text: $username)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    .padding(.horizontal)

            SecureField("Password", text: $password)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    .padding(.horizontal)

            HStack {
                Toggle(isOn: $rememberMe) {
                    Text("Remember Me")
                }
                        .padding(.horizontal)

                Spacer()

                Button(action: {
                    isLoading = true
                    showToast = true
                    signInWithCred(username: username, password: password) { success in
                        if success {
                            // Sign-in successful
                            isLoading = false
                            isLoggedIn = true
                        } else {
                            // Sign-in failed
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
                        Text("Login")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(8.0)
                    }
                }
                        .padding(.horizontal);
            }

            Spacer()

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
                        NavigationLink(
                                destination: ContentView()
                                        .navigationBarBackButtonHidden(true), // Hide the back button in ContentView
                                isActive: $isLoggedIn,
                                label: { EmptyView() }
                        )
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


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
