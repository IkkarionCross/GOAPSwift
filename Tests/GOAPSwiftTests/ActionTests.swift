import Foundation
import Testing

@testable import GOAPSwift

internal struct ActionTests {
    
    @Test
    func testOperableAction() {
        var action = Action(name: "testAction", cost: 1)
        action.add(precondition: (id: 0, value: true))
        action.add(effect: (id: 1, value: true))

        var worldState = WorldState(name: "test", priority: 50.0)
        worldState[0] = true

        #expect(action.isOperable(onWorldState: worldState) == true, "Action should be operable")
        
        let newWorldState = action.act(onWorldState: worldState)

        #expect(newWorldState[1] == true, "Effect should be applied to the world state")
    }

    @Test
    func testNotOperableAction() {
        var action = Action(name: "testAction", cost: 1)
        action.add(precondition: (id: 0, value: true))
        action.add(precondition: (id: 1, value: true))
        action.add(effect: (id: 1, value: true))

        var worldState = WorldState(name: "test", priority: 50.0)
        worldState[0] = true
        worldState[1] = false

        #expect(action.isOperable(onWorldState: worldState) == false, "Action should not be operable")
        
        let newWorldState = action.act(onWorldState: worldState)

        #expect(newWorldState[1] == false, "Effect should not be applied to the world state")
    }
    
}
