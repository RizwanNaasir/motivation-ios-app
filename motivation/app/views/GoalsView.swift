//
// Created by InterLink on 7/7/23.
//

import Foundation
import SwiftUI

struct GoalsView: View {
    @State private var isAddingGoal = false
    @State private var newGoalTitle = ""
    @State private var newGoalDescription = ""

    @ObservedObject private var goalsStore = GoalsStore()

    var body: some View {
        NavigationView {
            VStack {
                Divider()
                List {
                    ForEach(goalsStore.goals) { goal in
                        Button(action: {
                            // Show goal details or edit the goal
                            editGoal(goal)
                        }) {
                            GoalCard(goal: goal)
                        }
                    }
                            .onDelete(perform: deleteGoal)
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
                        .cornerRadius(8)
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
            goalsStore.deleteGoal(at: index)
        }
    }

    private func editGoal(_ goal: Goal) {
        let goalIndex = goalsStore.goals.firstIndex(of: goal)
        if let index = goalIndex {
            let editedGoal = goalsStore.goals[index]
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
