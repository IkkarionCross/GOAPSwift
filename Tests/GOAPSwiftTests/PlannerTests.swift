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

        for action in actions.reversed() {
            
            #expect(expectedActionsNames.contains(action.name) == true, "Unexpected action: \(action.name)")
            // guard expectedActionsNames.contains(action.name) else {
            //     Issue.record("Unexpected action: \(action.name)")
            //     return
            // }
            
            print(action.name)
        }
    }

}