//
// Created by InterLink on 7/7/23.
//

import Foundation
import SwiftUI

struct GoalsView: View {
    @State private var isAddingGoal = false
    @State private var newGoalTitle = ""
    @State private var newGoalDescription = ""
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject private var goalsStore = GoalsStore()

    var body: some View {

        NavigationView {
            VStack {
                Divider()
                if (goalsStore.get().isEmpty) {
                    Image("Empty") // Replace with your empty state image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding()
                            .padding(.bottom, 32.0)
                    Text("No Goals Found")
                            .padding(.bottom, 16.0)
                } else {
                    List {
                        ForEach(goalsStore.get()) { goal in
                            Button(action: {
                                // Show goal details or edit the goal
                                editGoal(goal)
                            }) {
                                GoalCard(goal: goal)
                            }
                        }
                                .onDelete(perform: deleteGoal)
                    }
                            .listStyle(PlainListStyle())
                            .background(
                                    RoundedRectangle(cornerRadius: 25)
                                            .fill(colorScheme == .dark ? Color.black : Color.white)
                            )
                }
                Button(action: {
                    isAddingGoal = true
                }) {
                    Text("Add Goal")
                }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .sheet(isPresented: $isAddingGoal) {
                            // AddGoalView or a form to add a new goal
                            AddGoalView(goalsViewModel: goalsStore, isPresented: $isAddingGoal)
                        }
                        .padding()
            }
                    .navigationBarTitle("Goals")
        }
    }

    private func deleteGoal(at offsets: IndexSet) {
        offsets.forEach { index in
            let id = goalsStore.get()[index].id
            goalsStore.deleteGoal(id: id)
        }
    }

    private func editGoal(_ goal: Goal) {
        let goalIndex = goalsStore.get().firstIndex(of: goal)
        if let index = goalIndex {
            let editedGoal = goalsStore.get()[index]
            isAddingGoal = true
            newGoalTitle = editedGoal.title
            newGoalDescription = editedGoal.description
        }
    }
}

struct GoalCard: View {
    var goal: Goal
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack(alignment: .leading) {
            Text(goal.title)
                    .font(.title)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
            Text(goal.description)
                    .font(.body)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
        }
    }
}
