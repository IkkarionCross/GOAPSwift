import Foundation


public protocol Executable {
    var name: String { get }
    var cost: Int { get }
}

public struct Action {

    public let name: String
    public let cost: Int

    public let executable: Executable

    private var preconditions: [WorldPropertyKey: Bool] // change to array
    private var effects: [WorldPropertyKey: Bool] // change to array

    public init(executable: Executable) {
        self.name = executable.name
        self.cost = executable.cost
        self.executable = executable
        self.preconditions = [:]
        self.effects = [:]
    }

    public mutating func add(precondition: (id: WorldPropertyProtocol, value: Bool)) {
        self.preconditions[WorldPropertyKey(key: precondition.id)] = precondition.value
    }

    public mutating func add(effect: (id: WorldPropertyProtocol, value: Bool)) {
        self.effects[WorldPropertyKey(key: effect.id)] = effect.value
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
        guard isOperable(onWorldState: worldState) else {
            return worldState
        }
        var newWorldState = WorldState.newWorldState(basedOn: worldState)
        for effect in effects {
            newWorldState[effect.key] = effect.value
        }
        return newWorldState
    }
    
}