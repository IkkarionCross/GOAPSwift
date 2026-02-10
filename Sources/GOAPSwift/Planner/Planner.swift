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
        guard !startState.meets(goalState: goal) else {
            return []
        }

        openAStar.removeAll()
        closedAStar.removeAll()

        let startingNode = NodeGOAP(
            state: startState, 
            parentId: 0, 
            cost: calculateHeuristic(withCurrent: startState, andGoal: goal), 
            costToGoal: 0, 
            action: nil
        )

        openAStar.append(startingNode)

        while openAStar.count > 0 {
            guard let current = extractNextNode() else {
                return []
            }

            if current.state.meets(goalState: goal) {
                return retracePath(from: current)
            }

            for potentialAction in actions {
                if !potentialAction.isOperable(onWorldState: current.state) {
                    continue;
                }

                let outcomeState = potentialAction.act(onWorldState: current.state)

                if isClosed(state: outcomeState) {
                    continue
                }

                if var outComeNode = find(state: outcomeState, in: openAStar),  
                    current.cost + potentialAction.cost < outComeNode.cost {
                     
                    outComeNode.parentId = current.id
                    outComeNode.cost = current.cost + potentialAction.cost
                    outComeNode.costToGoal = calculateHeuristic(withCurrent: outcomeState, andGoal: goal)
                    outComeNode.action = potentialAction

                    openAStar.sort(by: { $0 < $1 } )
                    
                } else {
                    let foundNode = NodeGOAP(
                        state: outcomeState, 
                        parentId: current.id, 
                        cost: current.cost + potentialAction.cost,
                        costToGoal: calculateHeuristic(withCurrent: outcomeState, andGoal: goal), 
                        action: potentialAction
                    )

                    add(toOpenList: foundNode)
                }
                
            }
        }
        
        return []
    }

    private func retracePath(from node: NodeGOAP) -> [Action] {
        var current: NodeGOAP? = node
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

    private func isClosed(state: WorldState) -> Bool {
        return find(state: state, in: closedAStar) != nil
    }

    private func find(state: WorldState, in list: [NodeGOAP]) -> NodeGOAP? {
        return list.first(where: { $0.state == state })
    }

    private func extractNextNode() -> NodeGOAP? {
        let node = openAStar.removeFirst()
        closedAStar.append(node)
        
        return node
    }

    private func add(toOpenList node: NodeGOAP) {
        openAStar.insertInOrder(of: node) { $0 < $1 }
    }

    private func calculateHeuristic(withCurrent current: WorldState,  andGoal goal: WorldState) -> Int {
        return current.distance(to: goal)
    }


}