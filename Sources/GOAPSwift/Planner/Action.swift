import Foundation

public protocol Executable {
    var name: String { get }
    var cost: Int { get }
}

public enum WorldCondition: Equatable, Hashable, Sendable {
    case equals(WorldValue)
    case notEquals(WorldValue)
    case greaterThan(Int)
    case atLeast(Int)
    case lessThan(Int)
    case atMost(Int)
    case within(ClosedRange<Int>)

    public func evaluate(_ actual: WorldValue) -> Bool {
        switch self {
        case .equals(let expected):
            return actual == expected
        case .notEquals(let expected):
            return actual != expected
        case .greaterThan(let expected):
            guard case .integer(let value) = actual else { return false }
            return value > expected
        case .atLeast(let expected):
            guard case .integer(let value) = actual else { return false }
            return value >= expected
        case .lessThan(let expected):
            guard case .integer(let value) = actual else { return false }
            return value < expected
        case .atMost(let expected):
            guard case .integer(let value) = actual else { return false }
            return value <= expected
        case .within(let range):
            guard case .integer(let value) = actual else { return false }
            return range.contains(value)
        }
    }
}

public enum WorldEffect: Equatable, Hashable, Sendable {
    case set(WorldValue)
    case increase(Int, maximum: Int?)
    case decrease(Int, minimum: Int?)

    internal func apply(to current: WorldValue?) -> WorldValue? {
        switch self {
        case .set(let value):
            return value
        case .increase(let amount, let maximum):
            assert(amount >= 0, "An increase amount cannot be negative")
            guard case .integer(let value) = current else {
                assertionFailure("An integer increase requires an existing integer world value")
                return nil
            }
            let result = value + amount
            return .integer(maximum.map { min(result, $0) } ?? result)
        case .decrease(let amount, let minimum):
            assert(amount >= 0, "A decrease amount cannot be negative")
            guard case .integer(let value) = current else {
                assertionFailure("An integer decrease requires an existing integer world value")
                return nil
            }
            let result = value - amount
            return .integer(minimum.map { max(result, $0) } ?? result)
        }
    }
}

public struct Action {
    public let name: String
    public let cost: Int
    public let executable: Executable

    private var preconditions: [WorldPropertyKey: WorldCondition]
    private var effects: [WorldPropertyKey: WorldEffect]

    public init(executable: Executable) {
        self.name = executable.name
        self.cost = executable.cost
        self.executable = executable
        self.preconditions = [:]
        self.effects = [:]
    }

    public mutating func add(precondition: (id: WorldPropertyProtocol, value: Bool)) {
        add(precondition: (
            id: precondition.id,
            condition: .equals(.boolean(precondition.value))
        ))
    }

    public mutating func add(
        precondition: (id: WorldPropertyProtocol, condition: WorldCondition)
    ) {
        preconditions[WorldPropertyKey(key: precondition.id)] = precondition.condition
    }

    public mutating func add(effect: (id: WorldPropertyProtocol, value: Bool)) {
        add(effect: (
            id: effect.id,
            effect: .set(.boolean(effect.value))
        ))
    }

    public mutating func add(
        effect: (id: WorldPropertyProtocol, effect: WorldEffect)
    ) {
        effects[WorldPropertyKey(key: effect.id)] = effect.effect
    }

    internal func isOperable(onWorldState worldState: WorldState) -> Bool {
        for (property, condition) in preconditions {
            guard let value = worldState[value: property],
                  condition.evaluate(value) else {
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
        for (property, effect) in effects {
            let current = newWorldState[value: property]
            if let result = effect.apply(to: current) {
                newWorldState[value: property] = result
            }
        }
        return newWorldState
    }
}
