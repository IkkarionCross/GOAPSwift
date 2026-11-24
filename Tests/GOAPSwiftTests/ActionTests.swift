import Foundation
import Testing

@testable import GOAPSwift

internal struct ActionTests {

    struct WorldStateMock: WorldPropertyProtocol {

        var name: String
        var id: Int

    }

    struct ActionMock: Executable {
        var name: String = "testAction"
        var cost: Int = 1
    }
    
    @Test
    func testOperableAction() {
        var action = Action(executable: ActionMock(name: "testAction", cost: 1))
        action.add(precondition: (id: WorldStateMock(name: String(), id: 0), value: true))
        action.add(effect: (id: WorldStateMock(name: String(), id: 1), value: true))

        var worldState = WorldState(name: "test", priority: 50.0)
        worldState[WorldStateMock(name: String(), id: 0)] = true

        #expect(action.isOperable(onWorldState: worldState) == true, "Action should be operable")
        
        let newWorldState = action.act(onWorldState: worldState)

        #expect(newWorldState[WorldStateMock(name: String(), id: 1)] == true, "Effect should be applied to the world state")
    }

    @Test
    func testNotOperableAction() {
        var action = Action(executable: ActionMock(name: "testAction", cost: 1))
        action.add(precondition: (id: WorldStateMock(name: String(), id: 0), value: true))
        action.add(precondition: (id: WorldStateMock(name: String(), id: 1), value: true))
        action.add(effect: (id: WorldStateMock(name: String(), id: 1), value: true))

        var worldState = WorldState(name: "test", priority: 50.0)
        worldState[WorldStateMock(name: String(), id: 0)] = true
        worldState[WorldStateMock(name: String(), id: 1)] = false

        #expect(action.isOperable(onWorldState: worldState) == false, "Action should not be operable")
        
        let newWorldState = action.act(onWorldState: worldState)

        #expect(newWorldState[WorldStateMock(name: String(), id: 1)] == false, "Effect should not be applied to the world state")
    }

    @Test
    func testCurrentBooleanActionAPIStillWorks() {
        let sighted = WorldStateMock(name: "foe_sighted", id: 0)
        let defeated = WorldStateMock(name: "foe_dead", id: 1)
        var action = Action(executable: ActionMock(name: "attack", cost: 1))
        action.add(precondition: (id: sighted, value: true))
        action.add(effect: (id: defeated, value: true))

        var state = WorldState(name: "game state", priority: 0)
        state[sighted] = true
        state[defeated] = false

        #expect(action.isOperable(onWorldState: state))
        #expect(action.act(onWorldState: state)[defeated] == true)
    }

    @Test(arguments: [
        (WorldCondition.equals(.integer(20)), 20, true),
        (WorldCondition.notEquals(.integer(20)), 21, true),
        (WorldCondition.greaterThan(20), 21, true),
        (WorldCondition.greaterThan(20), 20, false),
        (WorldCondition.atLeast(20), 20, true),
        (WorldCondition.lessThan(20), 19, true),
        (WorldCondition.lessThan(20), 20, false),
        (WorldCondition.atMost(20), 20, true),
        (WorldCondition.within(10...20), 15, true),
        (WorldCondition.within(10...20), 21, false),
    ])
    func testIntegerConditions(
        condition: WorldCondition,
        actual: Int,
        expected: Bool
    ) {
        #expect(condition.evaluate(.integer(actual)) == expected)
    }

    @Test
    func testBooleanConditionsAndTypeMismatch() {
        #expect(WorldCondition.equals(.boolean(true)).evaluate(.boolean(true)))
        #expect(WorldCondition.notEquals(.boolean(false)).evaluate(.boolean(true)))
        #expect(!WorldCondition.atLeast(20).evaluate(.boolean(true)))
        #expect(!WorldCondition.equals(.integer(1)).evaluate(.boolean(true)))
    }

    @Test
    func testIntegerPreconditionControlsOperability() {
        let energy = WorldStateMock(name: "energy", id: 0)
        var action = Action(executable: ActionMock(name: "attack", cost: 1))
        action.add(precondition: (id: energy, condition: .atLeast(20)))

        var state = WorldState(name: "energy state", priority: 0)
        state[integer: energy] = 19
        #expect(!action.isOperable(onWorldState: state))

        state[integer: energy] = 20
        #expect(action.isOperable(onWorldState: state))
    }

    @Test
    func testIntegerEffects() {
        let energy = WorldStateMock(name: "energy", id: 0)
        var state = WorldState(name: "energy state", priority: 0)
        state[integer: energy] = 30

        var spend = Action(executable: ActionMock(name: "spend", cost: 1))
        spend.add(effect: (id: energy, effect: .decrease(20, minimum: 0)))
        #expect(spend.act(onWorldState: state)[integer: energy] == 10)

        var recover = Action(executable: ActionMock(name: "recover", cost: 1))
        recover.add(effect: (id: energy, effect: .increase(80, maximum: 100)))
        #expect(recover.act(onWorldState: state)[integer: energy] == 100)

        var set = Action(executable: ActionMock(name: "set", cost: 1))
        set.add(effect: (id: energy, effect: .set(.integer(5))))
        #expect(set.act(onWorldState: state)[integer: energy] == 5)
    }
    
}
