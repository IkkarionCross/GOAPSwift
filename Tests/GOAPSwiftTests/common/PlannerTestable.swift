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
            
            print("Action: \(action.name)")
            
            #expect(expectedActionsNames.contains(action.name) == true, "Unexpected action: \(action.name)")

        }
        
    }

}