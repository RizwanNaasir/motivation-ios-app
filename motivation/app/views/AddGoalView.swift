//
// Created by InterLink on 7/7/23.
//

import SwiftUI

struct AddGoalView: View {
    @ObservedObject var goalsViewModel: GoalsStore
    @Binding var isPresented: Bool

    @State private var newGoalTitle = ""
    @State private var newGoalDescription = ""
    @State private var isTitleValid = true
    @State private var isDescriptionValid = true

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Goal Details")) {
                    TextField("Title", text: $newGoalTitle)
                            .onChange(of: newGoalTitle) { newValue in
                                validateTitle()
                            }
                            .foregroundColor(isTitleValid ? .primary : .red)
                            .overlay(
                                    VStack(alignment: .leading, spacing: 0) {
                                        if !isTitleValid {
                                            Text("Title is required")
                                                    .font(.caption)
                                                    .foregroundColor(.red)
                                                    .padding(.top, 2)
                                        }
                                    }
                                            .opacity(isTitleValid ? 0 : 1)
                                            .animation(
                                                    Animation
                                                            .easeInOut(duration: 1.5)
                                                            .repeatForever(autoreverses: true),
                                                    value: UUID()
                                            )

                            )
                    TextField("Description", text: $newGoalDescription)
                            .onChange(of: newGoalDescription) { newValue in
                                validateDescription()
                            }
                            .foregroundColor(isDescriptionValid ? .primary : .red)
                            .overlay(
                                    VStack(alignment: .leading, spacing: 0) {
                                        if !isDescriptionValid {
                                            Text("Description is required")
                                                    .font(.caption)
                                                    .foregroundColor(.red)
                                                    .padding(.top, 2)
                                        }
                                    }
                                            .opacity(isDescriptionValid ? 0 : 1)
                                            .animation(
                                                    Animation
                                                            .easeInOut(duration: 1.5)
                                                            .repeatForever(autoreverses: true),
                                                    value: UUID()
                                            )

                            )
                }

                Section {
                    Button(action: {
                        if validateForm() {
                            withAnimation {
                                goalsViewModel.addGoal(title: newGoalTitle, description: newGoalDescription)
                            }
                            isPresented = false
                        }
                    }) {
                        Text("Save Goal")
                    }
                }
            }
                    .navigationBarTitle("Add Goal")
        }
    }

    private func validateForm() -> Bool {
        validateTitle()
        validateDescription()
        return isTitleValid && isDescriptionValid
    }

    private func validateTitle() {
        isTitleValid = !newGoalTitle.isEmpty
    }

    private func validateDescription() {
        isDescriptionValid = !newGoalDescription.isEmpty
    }
}
