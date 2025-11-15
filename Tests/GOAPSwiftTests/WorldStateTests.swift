

import Testing

@testable import GOAPSwift

final class WorldStateTests {

    @Test
    func testShouldMeetGoal() {
        var worldState: WorldState = WorldState(name: "state 1", priority: 100)
        worldState[0] = true
        
        var goalState: WorldState = WorldState(name: "goal", priority: 100)
        goalState[0] = true


        #expect(worldState.meets(goalState: goalState))
    }

    @Test
    func testShouldNOTMeetGoal() {
        var worldState: WorldState = WorldState(name: "state 1", priority: 100)
        worldState[0] = false
        
        var goalState: WorldState = WorldState(name: "goal", priority: 100)
        goalState[0] = true


        #expect(!worldState.meets(goalState: goalState))
    }

    @Test
    func testShouldDistanceBetweenStates_No_Difference_WhenAllFalse() {
        var worldState: WorldState = WorldState(name: "state 1", priority: 100)
        worldState[1] = false
        worldState[2] = false
        worldState[3] = false
        worldState[4] = false

        var goalState: WorldState = WorldState(name: "goal", priority: 100)
        goalState[1] = false
        goalState[2] = false
        goalState[3] = false
        goalState[4] = false

        #expect(0 == worldState.distance(to: goalState))
    }

    @Test
    func testShouldDistanceBetweenStates_Be_1() {
        var worldState: WorldState = WorldState(name: "state 1", priority: 100)
        worldState[1] = false
        worldState[2] = false
        worldState[3] = false
        worldState[4] = false

        var goalState: WorldState = WorldState(name: "goal", priority: 100)
        goalState[1] = false
        goalState[2] = false
        goalState[3] = false
        goalState[4] = true

        #expect(1 == worldState.distance(to: goalState))
    }

    @Test
    func testShouldCalculateDistanceOnlyForTrue() {
        var worldState: WorldState = WorldState(name: "state 1", priority: 100)
        worldState[1] = false
        worldState[2] = false
        worldState[3] = false
        worldState[4] = false

        var goalState: WorldState = WorldState(name: "goal", priority: 100)
        goalState[1] = false
        goalState[2] = false
        goalState[3] = false
        goalState[4] = true

        #expect(1 ==  worldState.distance(to: goalState))

        goalState[4] = false

        #expect(0 == worldState.distance(to: goalState))
    }

    @Test
    func testShouldCalculateDistance() {
        var worldState: WorldState = WorldState(name: "state 1", priority: 100)
        worldState[1] = true
        worldState[2] = true
        worldState[3] = false
        worldState[4] = false

        var goalState: WorldState = WorldState(name: "goal", priority: 100)
        goalState[1] = false
        goalState[2] = false
        goalState[3] = false
        goalState[4] = true

        #expect(3 == worldState.distance(to: goalState))
    }

    @Test
    func testShouldBeEqual() {
        var worldState: WorldState = WorldState(name: "state 1", priority: 100)
        worldState[1] = false
        worldState[2] = false
        worldState[3] = false
        worldState[4] = false

        var goalState: WorldState = WorldState(name: "goal", priority: 100)
        goalState[1] = false
        goalState[2] = false
        goalState[3] = false
        goalState[4] = false

        #expect(goalState == worldState)
    }

}
