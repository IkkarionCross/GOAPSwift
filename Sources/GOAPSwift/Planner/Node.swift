import Foundation

public class NodeGOAP {

    public let state: WorldState
    public var id: Int 
    public var parentId: Int
    public var cost: Int
    public var costToGoal: Int
    public var action: Action?

    private static var last_id: Int = 0

    public init(
        state: WorldState,
        parentId: Int, 
        cost: Int, 
        costToGoal: Int, 
        action: Action?
    ) {
        NodeGOAP.last_id += 1
        self.state = state
        self.id = NodeGOAP.last_id
        self.parentId = parentId
        self.cost = cost 
        self.costToGoal = costToGoal
        self.action = action

    }

    public func f() -> Int {
        return cost + costToGoal
    }

    public func printDescription() {
        print("Node { \(id) parent: \(parentId) F: \(f()) G: \(cost) H: \(costToGoal) \(state.printedDescription) } ")
    }

    public static func <(lhs: NodeGOAP, rhs: NodeGOAP) -> Bool {
        return lhs.f() < rhs.f()
    }
}