import Foundation

public class Action {

    public let name: String
    public let cost: Int

    private var preconditions: [Int: Bool]

    private var effects: [Int: Bool]

    public init(name: String, cost: Int) {
        self.name = name
        self.cost = cost
        self.preconditions = [:]
        self.effects = [:]
    }

    public func setPrecondition(id: Int, value: Bool) {
        self.preconditions[id] = value
    }

    public func setEffect(id: Int, value: Bool) {
        self.effects[id] = value
    }

    func isOperable(onWorldState worldState: WorldState) -> Bool {
        for precondition in preconditions {
            if worldState[precondition.key] != precondition.value {
                return false
            }
        }
        return true 
    }

    func act(onWorldState worldState: WorldState) -> WorldState {
        var newWorldState = WorldState.newWorldState(basedOn: worldState)
        for effect in effects {
            newWorldState[effect.key] = effect.value
        }
        return newWorldState
    }

    
}