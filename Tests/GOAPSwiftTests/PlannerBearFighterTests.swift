

import Foundation
import Testing

@testable import GOAPSwift

final class PlannerBearFighterTests: PlannerTestable {

    var actions: [Action] = []

    let enemy_sighted = 0
    let enemy_dead = 1
    let enemy_in_range = 2
    let enemy_in_close_range = 3
    let enemy_in_avg_range = 4
    let me_dead = 5

    func createActions() {

        let searchEnemy = Action(name: "searchEnemy", cost: 250) // Patroll
        searchEnemy.setPrecondition(id: enemy_sighted, value: false)
        
        searchEnemy.setEffect(id: enemy_sighted, value: true)
        actions.append(searchEnemy)

        let bearFollowEnemy = Action(name: "bearFollowEnemy", cost: 150)
        bearFollowEnemy.setPrecondition(id: enemy_sighted, value: true)
        bearFollowEnemy.setPrecondition(id: enemy_in_range, value: false)
        
        bearFollowEnemy.setEffect(id: enemy_in_range, value: true)
        actions.append(bearFollowEnemy)

        let bearFollowEnemyToClose = Action(name: "bearFollowEnemyToClose", cost: 150)
        bearFollowEnemyToClose.setPrecondition(id: enemy_sighted, value: true)
        bearFollowEnemyToClose.setEffect(id: enemy_in_range, value: true)
        bearFollowEnemyToClose.setPrecondition(id: enemy_in_close_range, value: false)

        bearFollowEnemyToClose.setEffect(id: enemy_in_close_range, value: true)
        actions.append(bearFollowEnemyToClose)

        let AOEAttack = Action(name: "AOEAttack", cost: 50)
        AOEAttack.setPrecondition(id: enemy_in_avg_range, value: true)
        AOEAttack.setPrecondition(id: enemy_sighted, value: true)

        AOEAttack.setEffect(id: enemy_dead, value: true)
        actions.append(AOEAttack)

        let deathRayAttack = Action(name: "deathRayAttack", cost: 5)
        deathRayAttack.setPrecondition(id: enemy_in_range, value: true)
        deathRayAttack.setPrecondition(id: enemy_sighted, value: true)

        deathRayAttack.setEffect(id: enemy_dead, value: true)
        actions.append(deathRayAttack)

        let clawAttack = Action(name: "clawAttack", cost: 10)
        clawAttack.setPrecondition(id: enemy_sighted, value: true)
        clawAttack.setPrecondition(id: enemy_dead, value: false)
        clawAttack.setPrecondition(id: enemy_in_close_range, value: true)

        clawAttack.setEffect(id: enemy_dead, value: true)
        actions.append(clawAttack)

        let dead = Action(name: "dead", cost: 30)
        dead.setPrecondition(id: me_dead, value: true)

        dead.setEffect(id: me_dead, value: true)
        actions.append(dead)

    }

    func createGoalState() -> WorldState {
        var state = WorldState(name: "State", priority: 100)
        state[enemy_dead] = true
        state[me_dead] = false

        return state
    }

    func createInitialState() -> WorldState {
        var initialState = WorldState(name: "initial_state", priority: 0)
        initialState[enemy_dead] = false
        initialState[enemy_sighted] = false
        initialState[enemy_in_range] = false
        initialState[enemy_in_close_range] = false
        initialState[enemy_in_avg_range] = false
        initialState[me_dead] = false

        return initialState
    }

     func createInitialStateCloseRange() -> WorldState {
        var initialState = WorldState(name: "initial_state", priority: 0)
        initialState[enemy_dead] = false
        initialState[enemy_sighted] = true
        initialState[enemy_in_range] = false
        initialState[enemy_in_close_range] = true
        initialState[enemy_in_avg_range] = false
        initialState[me_dead] = false

        return initialState
    }

    func createInitialStateInRange() -> WorldState {
        var initialState = WorldState(name: "initial_state", priority: 0)
        initialState[enemy_dead] = false
        initialState[enemy_sighted] = true
        initialState[enemy_in_range] = true
        initialState[enemy_in_close_range] = true
        initialState[enemy_in_avg_range] = false
        initialState[me_dead] = false

        return initialState
    }
    
    @Test
    func testShouldRunPlanner() {

        let expectedActionsNames: [String] = [
            "searchEnemy",
            "bearFollowEnemy",
            "deathRayAttack",
        ]

        createActions()

        let initialState = createInitialState()
        let goalState = createGoalState()

        let planner = Planner()

        let nextActions = planner.plan(fromState: initialState, toGoalState: goalState, actions: actions)

        assert(actions: nextActions, expectedActionsNames: expectedActionsNames)
    }

    @Test
    func testShouldRunPlannerForCloseRangeState() {

        let expectedActionsNames: [String] = [
            "searchEnemy",
            "clawAttack",
            "bearFollowEnemy"
        ]

        createActions()

        let initialState = createInitialStateCloseRange()
        let goalState = createGoalState()

        let planner = Planner()

        let nextActions = planner.plan(fromState: initialState, toGoalState: goalState, actions: actions)

        assert(actions: nextActions, expectedActionsNames: expectedActionsNames)
    }

    @Test
    func testShouldRunPlannerForInRangeState() {

        let expectedActionsNames: [String] = [
            "searchEnemy",
            "deathRayAttack",
        ]

        createActions()

        let initialState = createInitialStateInRange()
        let goalState = createGoalState()

        let planner = Planner()

        let nextActions = planner.plan(fromState: initialState, toGoalState: goalState, actions: actions)

        assert(actions: nextActions, expectedActionsNames: expectedActionsNames)
    }

}