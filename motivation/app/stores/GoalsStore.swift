//
// Created by InterLink on 7/7/23.
//

import Foundation

class GoalsStore: ObservableObject {
    @Published var goals: [Goal] = []

    func addGoal(title: String, description: String) {
        let newGoal = Goal(title: title, description: description)
        goals.append(newGoal)
    }

    func deleteGoal(at index: Int) {
        goals.remove(at: index)
    }
}