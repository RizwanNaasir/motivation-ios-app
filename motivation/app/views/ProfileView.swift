//
// Created by InterLink on 7/3/23.
//

import SwiftUI

struct ProfileView: View {
    @State private var isLoading: Bool = false
    @State private var user: User?;
    var body: some View {
        NavigationView {
            VStack {
                if (isLoading && user == nil) {
                    ProgressView().padding()
                }
                if (user != nil && !isLoading) {
                    VStack(alignment: .leading, spacing: 12) {
                        ProfileField(label: "First Name", value: (user?.name)!)
                        ProfileField(label: "Last Name", value: (user?.surname)!)
                        ProfileField(label: "Age", value: (user?.age)!)
                        ProfileField(label: "Gender", value: (user?.gender)!)
                        ProfileField(label: "Favorite Hobby", value: (user?.favouriteHobby)!)
                        ProfileField(label: "Personality Type", value: (user?.personaltyType)!)
                    }
                            .padding()

                } else {
                    Image("Empty") // Replace with your empty state image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding()
                            .padding(.bottom, 32.0)
                    Text("Quite Empty Hun!")
                            .padding(.bottom, 16.0)
                }
                Spacer()
            }
                    .onAppear {
                        getProfile()
                    }
                    .navigationBarTitle("Profile")

        }
    }

    private func getProfile() {
        isLoading = true
        requestData(USER_PROFILE, method: "GET") { (response: Response<User>?, error) in
            isLoading = false
            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let response = response else {
                print("No response data")
                return
            }

            if let userResponse = response.data {
                user = userResponse
            } else {
                print("No data in the response")
            }
        }
    }
}

struct ProfileField<T>: View where T: LosslessStringConvertible {
    let label: String
    var value: T

    var body: some View {
        HStack {
            Text(label)
                    .font(.headline)
            Spacer()
            Text(value.description)
                    .font(.subheadline)
        }
    }
}

