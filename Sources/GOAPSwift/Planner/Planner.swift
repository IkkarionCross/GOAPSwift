import Foundation

public class Planner {

    internal var openAStar: [NodeGOAP]
    internal var closedAStar: [NodeGOAP]

    public init() {
        self.openAStar = []
        self.closedAStar = []
    }
    
    public func plan(fromState startState: WorldState, toGoalState goal: WorldState, actions: [Action]) -> [Action] {
        
        guard !startState.meets(goalState: goal) else {
            GOAPLogger.logger.notice("Start state already meets the goal")
            return []
        }
    
        GOAPLogger.logger.notice("Cleaning up previous states")
        
        openAStar.removeAll()
        closedAStar.removeAll()

        GOAPLogger.logger.debug("Open list state: \(self.openAStar.isEmpty ? "Empty" : self.printOpenList())")
        GOAPLogger.logger.debug("Closed list state: \(self.closedAStar.isEmpty ? "Empty" : self.printClosedList())")

        let startingNode = NodeGOAP(
            state: startState, 
            parentId: 0, 
            cost: calculateHeuristic(withCurrent: startState, andGoal: goal), 
            costToGoal: 0, 
            action: nil
        )

        openAStar.append(startingNode)
        GOAPLogger.logger.notice("Planner started")
        while openAStar.count > 0 {
            
            guard let current = extractNextNode() else {
                GOAPLogger.logger.critical("Planner failed to extract next node")
                return []
            }

            GOAPLogger.logger.debug("Processing node with state: \(current.state.printedDescription)")

            if current.state.meets(goalState: goal) {
                GOAPLogger.logger.debug("Found goal state retracing path")
                return retracePath(from: current)
            }

            for potentialAction in actions {
                if !potentialAction.isOperable(onWorldState: current.state) {
                    GOAPLogger.logger.debug("Action not operable: \(potentialAction.name) in: \(current.state.printedDescription)")
                    continue;
                }

                let outcomeState = potentialAction.act(onWorldState: current.state)

                if isClosed(state: outcomeState) {
                    GOAPLogger.logger.debug("Outcome state already closed: \(outcomeState.printedDescription)")
                    continue
                }

                if let outComeNode = find(state: outcomeState, in: openAStar),  
                    current.cost + potentialAction.cost < outComeNode.cost {
                        
                    GOAPLogger.logger.debug("Found better path to node with state: \(outcomeState.printedDescription) updating path with \(potentialAction.name)")
                     
                    outComeNode.parentId = current.id
                    outComeNode.cost = current.cost + potentialAction.cost
                    outComeNode.costToGoal = calculateHeuristic(withCurrent: outcomeState, andGoal: goal)
                    outComeNode.action = potentialAction

                    GOAPLogger.logger.debug("Sorting open list after updating node with state: \(outcomeState.printedDescription)")
                    openAStar.sort(by: { $0 < $1 } )
                    
                } else {
                    let foundNode = NodeGOAP(
                        state: outcomeState, 
                        parentId: current.id, 
                        cost: current.cost + potentialAction.cost,
                        costToGoal: calculateHeuristic(withCurrent: outcomeState, andGoal: goal), 
                        action: potentialAction
                    )

                    GOAPLogger.logger.debug("Adding new node to open list with action: \(potentialAction.name)")

                    add(toOpenList: foundNode)
                }

                GOAPLogger.logger.debug("Open list state: \(self.printOpenList())")
                GOAPLogger.logger.debug("Closed list state: \(self.printClosedList())")
                
            }
        }
        
        return []
    }

    private func retracePath(from node: NodeGOAP) -> [Action] {
        var current: NodeGOAP? = node
        var thePlan: [Action] = []
        repeat {
            
            if let action = current?.action {
                GOAPLogger.logger.debug("adding action to path: \(action.name)")
                thePlan.append(action)
            }

            var previousNode: NodeGOAP? = openAStar.first { $0.id == current?.parentId }
            if previousNode == nil {
                previousNode = closedAStar.first { $0.id == current?.parentId }
            }

            current = previousNode
        
        } while (current?.parentId != 0)
        
        GOAPLogger.logger.debug("Returning plan with \(thePlan.count) actions")
        // retracePath walks backward from the goal node to the start node, so
        // `thePlan` is built in reverse (last action first). Reverse it so that
        // plan[0] is the first action to execute.
        return Array(thePlan.reversed())
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

    private func printOpenList() -> String {
        var output = ""
         for node in openAStar {
            output += node.printDescription() + "\n"
        }
        return output
    }

    private func printClosedList() -> String {
        var output = ""
        for node in closedAStar {
            output += node.printDescription() + "\n"
        }
        return output
    }

}