

import Testing

@testable import GOAPSwift

final class WorldStateTests {

    struct WorldStateMock: WorldPropertyProtocol {

        var name: String
        var id: Int

    }

    @Test
    func testShouldMeetGoal() {
        var worldState: WorldState = WorldState(name: "state 1", priority: 100)
        worldState[WorldStateMock(name: String(), id: 0)] = true
        
        var goalState: WorldState = WorldState(name: "goal", priority: 100)
        goalState[WorldStateMock(name: String(), id: 0)] = true


        #expect(worldState.meets(goalState: goalState))
    }

    @Test
    func testShouldNOTMeetGoal() {
        var worldState: WorldState = WorldState(name: "state 1", priority: 100)
        worldState[WorldStateMock(name: String(), id: 0)] = false
        
        var goalState: WorldState = WorldState(name: "goal", priority: 100)
        goalState[WorldStateMock(name: String(), id: 0)] = true


        #expect(!worldState.meets(goalState: goalState))
    }

    @Test
    func testShouldDistanceBetweenStates_No_Difference_WhenAllFalse() {
        var worldState: WorldState = WorldState(name: "state 1", priority: 100)
        worldState[WorldStateMock(name: String(), id: 1)] = false
        worldState[WorldStateMock(name: String(), id: 2)] = false
        worldState[WorldStateMock(name: String(), id: 3)] = false
        worldState[WorldStateMock(name: String(), id: 4)] = false

        var goalState: WorldState = WorldState(name: "goal", priority: 100)
        goalState[WorldStateMock(name: String(), id: 1)] = false
        goalState[WorldStateMock(name: String(), id: 2)] = false
        goalState[WorldStateMock(name: String(), id: 3)] = false
        goalState[WorldStateMock(name: String(), id: 4)] = false

        #expect(0 == worldState.distance(to: goalState))
    }

    @Test
    func testShouldDistanceBetweenStates_Be_1() {
        var worldState: WorldState = WorldState(name: "state 1", priority: 100)
        worldState[WorldStateMock(name: String(), id: 1)] = false
        worldState[WorldStateMock(name: String(), id: 2)] = false
        worldState[WorldStateMock(name: String(), id: 3)] = false
        worldState[WorldStateMock(name: String(), id: 4)] = false

        var goalState: WorldState = WorldState(name: "goal", priority: 100)
        goalState[WorldStateMock(name: String(), id: 1)] = false
        goalState[WorldStateMock(name: String(), id: 2)] = false
        goalState[WorldStateMock(name: String(), id: 3)] = false
        goalState[WorldStateMock(name: String(), id: 4)] = true

        #expect(1 == worldState.distance(to: goalState))
    }

    @Test
    func testShouldCalculateDistanceOnlyForTrue() {
        var worldState: WorldState = WorldState(name: "state 1", priority: 100)
        worldState[WorldStateMock(name: String(), id: 1)] = false
        worldState[WorldStateMock(name: String(), id: 2)] = false
        worldState[WorldStateMock(name: String(), id: 3)] = false
        worldState[WorldStateMock(name: String(), id: 4)] = false

        var goalState: WorldState = WorldState(name: "goal", priority: 100)
        goalState[WorldStateMock(name: String(), id: 1)] = false
        goalState[WorldStateMock(name: String(), id: 2)] = false
        goalState[WorldStateMock(name: String(), id: 3)] = false
        goalState[WorldStateMock(name: String(), id: 4)] = true

        #expect(1 ==  worldState.distance(to: goalState))

        goalState[WorldStateMock(name: String(), id: 4)] = false

        #expect(0 == worldState.distance(to: goalState))
    }

    @Test
    func testShouldCalculateDistance() {
        var worldState: WorldState = WorldState(name: "state 1", priority: 100)
        worldState[WorldStateMock(name: String(), id: 1)] = true
        worldState[WorldStateMock(name: String(), id: 2)] = true
        worldState[WorldStateMock(name: String(), id: 3)] = false
        worldState[WorldStateMock(name: String(), id: 4)] = false

        var goalState: WorldState = WorldState(name: "goal", priority: 100)
        goalState[WorldStateMock(name: String(), id: 1)] = false
        goalState[WorldStateMock(name: String(), id: 2)] = false
        goalState[WorldStateMock(name: String(), id: 3)] = false
        goalState[WorldStateMock(name: String(), id: 4)] = true

        #expect(3 == worldState.distance(to: goalState))
    }

    @Test
    func testShouldBeEqual() {
        var worldState: WorldState = WorldState(name: "state 1", priority: 100)
        worldState[WorldStateMock(name: String(), id: 1)] = false
        worldState[WorldStateMock(name: String(), id: 2)] = false
        worldState[WorldStateMock(name: String(), id: 3)] = false
        worldState[WorldStateMock(name: String(), id: 4)] = false

        var goalState: WorldState = WorldState(name: "goal", priority: 100)
        goalState[WorldStateMock(name: String(), id: 1)] = false
        goalState[WorldStateMock(name: String(), id: 2)] = false
        goalState[WorldStateMock(name: String(), id: 3)] = false
        goalState[WorldStateMock(name: String(), id: 4)] = false

        #expect(goalState == worldState)
    }

}
