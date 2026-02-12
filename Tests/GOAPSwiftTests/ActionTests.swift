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
    
}
