import Foundation

public class Planner {

    internal var openAStar: [NodeGOAP]
    internal var closedAStar: [NodeGOAP]

    public init() {
        self.openAStar = []
        self.closedAStar = []
    }

    public func printOpenList() {
        for node in openAStar {
            node.printDescription()
        }
    }

    public func printClosedList() {
        for node in closedAStar {
            node.printDescription()
        }
    }

    public func plan(fromState startState: WorldState, toGoalState goal: WorldState, actions: [Action]) -> [Action] {
        if startState.meets(goalState: goal) {
            return []
        }

        openAStar.removeAll()
        closedAStar.removeAll()

        let startingNode = NodeGOAP(
            state: startState, 
            parentId: 0, 
            cost: calculateHeuristic(current: startState, goal: goal), 
            costToGoal: 0, 
            action: nil
        )

        openAStar.append(startingNode)

        while openAStar.count > 0 {
            guard let current = popAndAddToClose() else {
                return []
            }

            if current.state.meets(goalState: goal){
                var current: NodeGOAP? = current
                var thePlan: [Action] = []
                repeat {
                    if let action = current?.action {
                        thePlan.append(action)
                    }

                    var previousNode: NodeGOAP? = openAStar.first { $0.id == current?.parentId }
                    if previousNode == nil {
                        previousNode = closedAStar.first { $0.id == current?.parentId }
                    }

                    current = previousNode
                
                } while (current?.parentId != 0)

                return thePlan
            }

            for potentialAction in actions {
                if !potentialAction.isOperable(onWorldState: current.state) {
                    continue;
                }
                let outcomeState = potentialAction.act(onWorldState: current.state)

                if isClosed(state: outcomeState) {
                    continue
                }

                if var outComeNode = isOpen(state: outcomeState),  
                    current.cost + potentialAction.cost < outComeNode.cost {
                    
                    outComeNode.parentId = current.id
                    outComeNode.cost = current.cost + potentialAction.cost
                    outComeNode.costToGoal = calculateHeuristic(current: outcomeState, goal: goal)
                    outComeNode.action = potentialAction

                    openAStar.sort(by: { $0 < $1 } )
                } else {
                    let foundNode = NodeGOAP(
                        state: outcomeState, 
                        parentId: current.id, 
                        cost: current.cost + potentialAction.cost,
                        costToGoal: calculateHeuristic(current: outcomeState, goal: goal), 
                        action: potentialAction
                    )

                    addToOpen(node: foundNode)
                }
                
            }
        }

        print("No plan found for this start and goal")

        return []
    }

    private func isClosed(state: WorldState) -> Bool {
        return closedAStar.contains(where: { $0.state == state })
    }

    private func isOpen(state: WorldState) -> NodeGOAP? {
        return openAStar.first(where: { $0.state == state })
    }

    internal func popAndAddToClose() -> NodeGOAP? {
        let node = openAStar.removeFirst()
        closedAStar.append(node)
        
        return node
    }

    private func addToOpen(node: NodeGOAP) {
        openAStar.insertInOrder(of: node) { $0 < $1 }
    }

    private func calculateHeuristic(current: WorldState, goal: WorldState) -> Int {
        return current.distance(to: goal)
    }


}