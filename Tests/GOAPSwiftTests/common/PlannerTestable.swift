import Foundation
import Testing

@testable import GOAPSwift

protocol PlannerTestable {
    func assert(actions: [Action], expectedActionsNames: [String])
}

extension PlannerTestable {

    func assert(actions: [Action], expectedActionsNames: [String]) {

        if actions.isEmpty {
            Issue.record("No plan found")
            return
        }

        print("Listing next actions")

        // `actions` is already in execution order (plan[0] runs first), so we
        // iterate it directly — no `.reversed()` needed.
        for action in actions {

            print("Action: \(action.name)")

            #expect(expectedActionsNames.contains(action.name) == true, "Unexpected action: \(action.name)")

        }
        
    }

}