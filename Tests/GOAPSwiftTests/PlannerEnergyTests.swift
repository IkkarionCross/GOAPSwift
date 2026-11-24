import Testing

@testable import GOAPSwift

final class PlannerEnergyTests {

    enum Property: Int, WorldPropertyProtocol {
        case energy
        case foeDead

        var id: Int { rawValue }

        var name: String {
            switch self {
            case .energy: return "energy"
            case .foeDead: return "foe_dead"
            }
        }
    }

    struct ExecutableAction: Executable {
        let name: String
        let cost: Int
    }

    @Test
    func plannerExcludesAnUnaffordableActionAndSelectsAnAffordableOne() {
        var expensive = Action(executable: ExecutableAction(name: "expensive", cost: 1))
        expensive.add(precondition: (id: Property.energy, condition: .atLeast(40)))
        expensive.add(effect: (id: Property.energy, effect: .decrease(40, minimum: 0)))
        expensive.add(effect: (id: Property.foeDead, value: true))

        var cheap = Action(executable: ExecutableAction(name: "cheap", cost: 5))
        cheap.add(precondition: (id: Property.energy, condition: .atLeast(10)))
        cheap.add(effect: (id: Property.energy, effect: .decrease(10, minimum: 0)))
        cheap.add(effect: (id: Property.foeDead, value: true))

        var initial = WorldState(name: "initial", priority: 0)
        initial[integer: Property.energy] = 20
        initial[Property.foeDead] = false

        var goal = WorldState(name: "goal", priority: 0)
        goal[Property.foeDead] = true

        let plan = Planner().plan(
            fromState: initial,
            toGoalState: goal,
            actions: [expensive, cheap]
        )

        #expect(plan.map(\.name) == ["cheap"])
    }

    @Test
    func plannerCanRecoverEnergyBeforeAnExpensiveAction() {
        var recover = Action(executable: ExecutableAction(name: "recover", cost: 1))
        recover.add(precondition: (id: Property.energy, condition: .lessThan(40)))
        recover.add(effect: (id: Property.energy, effect: .increase(30, maximum: 100)))

        var expensive = Action(executable: ExecutableAction(name: "expensive", cost: 1))
        expensive.add(precondition: (id: Property.energy, condition: .atLeast(40)))
        expensive.add(effect: (id: Property.energy, effect: .decrease(40, minimum: 0)))
        expensive.add(effect: (id: Property.foeDead, value: true))

        var initial = WorldState(name: "initial", priority: 0)
        initial[integer: Property.energy] = 10
        initial[Property.foeDead] = false

        var goal = WorldState(name: "goal", priority: 0)
        goal[Property.foeDead] = true

        let plan = Planner().plan(
            fromState: initial,
            toGoalState: goal,
            actions: [expensive, recover]
        )

        #expect(plan.map(\.name) == ["recover", "expensive"])
    }
}
