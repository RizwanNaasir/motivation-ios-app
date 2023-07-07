import Foundation

class GoalsStore: ObservableObject {
    @Published var goals: [Goal] = []

    init() {
        fetchGoals()
    }

    public func get() -> [Goal] {
        if goals.isEmpty {
            fetchGoals()
        }
        return goals
    }

    private func fetchGoals() {
        requestData(GOAL, method: "GET") { (response: Response<[Goal]>?, error) in
            DispatchQueue.main.async {
                if error != nil {
                    return
                }
                for item in response?.data ?? [] {
                    if !self.goals.contains(where: { $0.id == item.id }) {
                        self.goals.append(item)
                    }
                }
                return
            }
        }
    }

    func addGoal(title: String, description: String) {
        let params = ["title": title, "description": description]
        requestData(GOAL, method: "POST", parameters: params) { [self] (response: Response<Goal>?, error) in
            DispatchQueue.main.async { [self] in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                if let response = response {
                    goals.append(response.data!)
                }
            }
        }
    }

    func deleteGoal(id: Int?) {
        guard let id = id else {
            return
        }

        guard let index = goals.firstIndex(where: { $0.id == id }) else {
            return
        }

        goals.remove(at: index)

        request(GOAL + "/" + String(id), method: "DELETE") { error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                print("Successfully deleted goal")
            }
        }
    }

    func updateGoal(id: Int?, title: String, description: String) {
        let params = ["title": title, "description": description]
        let index = goals.firstIndex(where: { $0.id == id })!
        goals[index].title = title
        goals[index].description = description
        request(GOAL + "/" + String(id ?? 0), method: "PUT", parameters: params) { error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                print("Successfully updated goal")
            }
        }
    }
}
