import Foundation

public protocol WorldPropertyProtocol {
    var id: Int { get }
    var name: String { get }
}

internal struct WorldPropertyKey: Hashable, Equatable, WorldPropertyProtocol {

    internal let id: Int
    internal let name: String

    private let key: WorldPropertyProtocol

    internal init(key: WorldPropertyProtocol) {
        self.id = key.id
        self.name = key.name
        self.key = key
    }

    internal func hash(into hasher: inout Hasher) {
        hasher.combine(key.id)
        hasher.combine(key.name)
    }

    internal static func ==(lhs: WorldPropertyKey, _ rhs: WorldPropertyKey) -> Bool {
        return lhs.key.id == rhs.key.id && lhs.key.name == rhs.key.name
    }
}

public struct WorldState {

    public let priority: Float
    public let name: String

    public var printedDescription: String {
        var result = "WorldState { "
        for item in vars {
            result.append("id: \(item.key.id) key: \(item.key.name) value: \(item.value) \n")
        }
        result.append(" }")
        return result
    }

    private var vars: [WorldPropertyKey: Bool]

    public init(name: String, priority: Float) {
        self.name = name
        self.priority = priority
        self.vars = [:]
    }

    public func meets(goalState state: WorldState) -> Bool {
        for item in state.vars {
            if self.vars[item.key] != item.value {
                return false
            }
        }
        return true
    }

    /*
        How many variables of this state differs from the other state?
    */
    public func distance(to state: WorldState) -> Int {
        var result = 0
        for item in state.vars {
            if vars[item.key] != item.value {
                result += 1
            }
        }
        return result
    }

    public static func newWorldState(basedOn state: WorldState) -> WorldState {
        var newState = WorldState(name: state.name, priority: state.priority)
        for item in state.vars {
            newState.vars[item.key] = item.value
        }
        return newState
    }

    public static func ==(lhs: WorldState, _ rhs: WorldState) -> Bool {
        return lhs.vars == rhs.vars
    }

    public subscript(key: WorldPropertyProtocol) -> Bool? {
        get {
            return vars[WorldPropertyKey(key: key)]
        }
        set {
            vars[WorldPropertyKey(key: key)] = newValue
        }
    }

}