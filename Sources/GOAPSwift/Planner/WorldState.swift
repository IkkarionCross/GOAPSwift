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
        lhs.key.id == rhs.key.id && lhs.key.name == rhs.key.name
    }
}

public enum WorldValue: Equatable, Hashable, Sendable, CustomStringConvertible {
    case boolean(Bool)
    case integer(Int)

    public var description: String {
        switch self {
        case .boolean(let value): return String(value)
        case .integer(let value): return String(value)
        }
    }
}

public struct WorldState: Equatable {
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

    private var vars: [WorldPropertyKey: WorldValue]

    public init(name: String, priority: Float) {
        self.name = name
        self.priority = priority
        self.vars = [:]
    }

    public func meets(goalState state: WorldState) -> Bool {
        for item in state.vars {
            if vars[item.key] != item.value {
                return false
            }
        }
        return true
    }

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
        newState.vars = state.vars
        return newState
    }

    public static func ==(lhs: WorldState, rhs: WorldState) -> Bool {
        lhs.vars == rhs.vars
    }

    public subscript(key: WorldPropertyProtocol) -> Bool? {
        get {
            guard case .boolean(let value) = vars[WorldPropertyKey(key: key)] else {
                return nil
            }
            return value
        }
        set {
            let property = WorldPropertyKey(key: key)
            if let newValue {
                vars[property] = .boolean(newValue)
            } else {
                vars[property] = nil
            }
        }
    }

    public subscript(integer key: WorldPropertyProtocol) -> Int? {
        get {
            guard case .integer(let value) = vars[WorldPropertyKey(key: key)] else {
                return nil
            }
            return value
        }
        set {
            let property = WorldPropertyKey(key: key)
            if let newValue {
                vars[property] = .integer(newValue)
            } else {
                vars[property] = nil
            }
        }
    }

    public subscript(value key: WorldPropertyProtocol) -> WorldValue? {
        get {
            vars[WorldPropertyKey(key: key)]
        }
        set {
            vars[WorldPropertyKey(key: key)] = newValue
        }
    }
}
