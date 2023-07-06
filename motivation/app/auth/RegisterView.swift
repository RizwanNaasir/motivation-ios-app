import SwiftUI
import ActionButton

struct RegisterView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading: Bool = false
    @State private var showToast: Bool = false
    @SceneStorage("isRegistered") private var isRegistered: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @State var actionButtonState: ActionButtonState =
            .enabled(title: "Register", systemImage: "bolt")
    @AppStorage("AuthToken") var authToken: String?

    var body: some View {
        VStack {
            Text("Register")
                    .font(.largeTitle)
                    .padding()

            CustomTextField(
                    text: $name,
                    placeholder: "Name",
                    keyboardType: .default,
                    textContentType: .name
            )

            CustomTextField(
                    text: $email,
                    placeholder: "Email",
                    keyboardType: .emailAddress,
                    textContentType: .emailAddress
            )

            SecureField("Password", text: $password)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    .padding(.horizontal)

            Spacer().padding()

            ActionButton(state: $actionButtonState, onTap: {
                actionButtonState = .loading(title: "Wait", systemImage: "bolt")
                registerWithData(name: name, email: email, password: password) { success in
                    if success {
                        // Sign-in successful
                        isRegistered = true
                        actionButtonState = .enabled(title: "Registered!", systemImage: "checkmark")
                    } else {
                        // Sign-in failed
                        actionButtonState = .enabled(title: "Register", systemImage: "bolt")
                    }
                }
            }, backgroundColor: Color.blue)
                    .frame(maxWidth: .infinity) // Make the button full width
                    .padding()
                    .cornerRadius(8.0)
                    .shadow(color: colorScheme == .dark ? .white.opacity(0.01) : .black.opacity(0.1), radius: 15, x: 0, y: 5)

            Spacer()
        }
                .padding()
                .background(
                        NavigationStack {
                            EmptyView() // Add an empty view as a workaround
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

//struct RegisterView_Previews: PreviewProvider {
//    static var previews: some View {
//        RegisterView()
//    }
//}
