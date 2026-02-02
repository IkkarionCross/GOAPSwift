import Foundation

public struct Action {

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

    public mutating func add(precondition: (id: Int, value: Bool)) {
        self.preconditions[precondition.id] = precondition.value
    }

    public mutating func add(effect: (id: Int, value: Bool)) {
        self.effects[effect.id] = effect.value
    }

    internal func isOperable(onWorldState worldState: WorldState) -> Bool {
        for precondition in preconditions {
            if worldState[precondition.key] != precondition.value {
                return false
            }
        }
        return true 
    }

    internal func act(onWorldState worldState: WorldState) -> WorldState {
        var newWorldState = WorldState.newWorldState(basedOn: worldState)
        for effect in effects {
            newWorldState[effect.key] = effect.value
        }
        return newWorldState
    }
    
}