

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
    let is_taking_close_hit = 5
    let is_taking_range_hit = 6
    let is_taking_avg_range_hit = 7
    let life_less_than_50_percent = 8
    let enemy_is_getting_away = 9
    let is_time_to_two_claw_attack = 10
    let me_dead = 11

    func createActions() {

        let patrolling = Action(name: "patrolling", cost: 250) // Patroll
        patrolling.setPrecondition(id: enemy_sighted, value: false)
        
        patrolling.setEffect(id: enemy_sighted, value: true)
        actions.append(patrolling)

        let bearFollowEnemy = Action(name: "bearFollowEnemy", cost: 70)
        bearFollowEnemy.setPrecondition(id: enemy_sighted, value: true)
        bearFollowEnemy.setPrecondition(id: enemy_in_range, value: false)
        
        bearFollowEnemy.setEffect(id: enemy_in_range, value: true)
        actions.append(bearFollowEnemy)

        let bearFollowEnemyToAvgRange = Action(name: "bearFollowEnemyToAvgRange", cost: 70)
        bearFollowEnemyToAvgRange.setPrecondition(id: enemy_sighted, value: true)
        bearFollowEnemyToAvgRange.setPrecondition(id: enemy_in_avg_range, value: false)
        
        bearFollowEnemyToAvgRange.setEffect(id: enemy_in_avg_range, value: true)
        actions.append(bearFollowEnemyToAvgRange)

        let bearFollowEnemyToCloseRange = Action(name: "bearFollowEnemyToCloseRange", cost: 70)
        bearFollowEnemyToCloseRange.setPrecondition(id: enemy_sighted, value: true)
        bearFollowEnemyToCloseRange.setPrecondition(id: enemy_in_close_range, value: false)
        
        bearFollowEnemyToCloseRange.setEffect(id: enemy_in_close_range, value: true)
        actions.append(bearFollowEnemyToCloseRange)

        let deathRayAttack = Action(name: "deathRayAttack", cost: 5)
        deathRayAttack.setPrecondition(id: enemy_in_range, value: true)
        deathRayAttack.setPrecondition(id: enemy_sighted, value: true)
        deathRayAttack.setPrecondition(id: enemy_dead, value: false)

        deathRayAttack.setEffect(id: enemy_dead, value: true)
        actions.append(deathRayAttack)

        let AOEAttack = Action(name: "AOEAttack", cost: 50)
        AOEAttack.setPrecondition(id: enemy_in_avg_range, value: true)
        AOEAttack.setPrecondition(id: enemy_dead, value: false)
        AOEAttack.setPrecondition(id: enemy_sighted, value: true)

        AOEAttack.setEffect(id: enemy_dead, value: true)
        actions.append(AOEAttack)

        let clawAttack = Action(name: "clawAttack", cost: 5)
        clawAttack.setPrecondition(id: enemy_sighted, value: true)
        clawAttack.setPrecondition(id: enemy_dead, value: false)
        clawAttack.setPrecondition(id: enemy_in_close_range, value: true)
        clawAttack.setPrecondition(id: is_time_to_two_claw_attack, value: false)

        clawAttack.setEffect(id: enemy_dead, value: true)
        actions.append(clawAttack)

        let counterClawAttack = Action(name: "counterClawAttack", cost: 10)
        counterClawAttack.setPrecondition(id: enemy_sighted, value: true)
        counterClawAttack.setPrecondition(id: enemy_dead, value: false)
        counterClawAttack.setPrecondition(id: enemy_in_close_range, value: true)
        counterClawAttack.setPrecondition(id: is_taking_close_hit, value: true)

        counterClawAttack.setEffect(id: enemy_dead, value: true)
        actions.append(counterClawAttack)

        let counterDeathRayAttack = Action(name: "counterDeathRayAttack", cost: 10)
        counterDeathRayAttack.setPrecondition(id: enemy_sighted, value: true)
        counterDeathRayAttack.setPrecondition(id: enemy_dead, value: false)
        counterDeathRayAttack.setPrecondition(id: enemy_in_range, value: true)
        counterDeathRayAttack.setPrecondition(id: is_taking_range_hit, value: true)

        counterDeathRayAttack.setEffect(id: enemy_dead, value: true)
        actions.append(counterDeathRayAttack)

        let counterAOEAttack = Action(name: "counterAOEAttack", cost: 10)
        counterAOEAttack.setPrecondition(id: enemy_sighted, value: true)
        counterAOEAttack.setPrecondition(id: enemy_dead, value: false)
        counterAOEAttack.setPrecondition(id: enemy_in_avg_range, value: true)
        counterAOEAttack.setPrecondition(id: is_taking_avg_range_hit, value: true)

        counterAOEAttack.setEffect(id: enemy_dead, value: true)
        actions.append(counterAOEAttack)

        let beserkMode = Action(name: "beserkMode", cost: 50)
        beserkMode.setPrecondition(id: enemy_sighted, value: true)
        beserkMode.setPrecondition(id: enemy_dead, value: false)
        beserkMode.setPrecondition(id: life_less_than_50_percent, value: true)

        beserkMode.setEffect(id: enemy_dead, value: true)
        actions.append(beserkMode)

        let getCloseTwoClawAttack = Action(name: "getCloseTwoClawAttack", cost: 30)
        getCloseTwoClawAttack.setPrecondition(id: enemy_sighted, value: true)
        getCloseTwoClawAttack.setPrecondition(id: enemy_dead, value: false)
        getCloseTwoClawAttack.setPrecondition(id: enemy_in_close_range, value: true)
        getCloseTwoClawAttack.setPrecondition(id: is_time_to_two_claw_attack, value: true)

        getCloseTwoClawAttack.setEffect(id: enemy_dead, value: true)
        actions.append(getCloseTwoClawAttack)

        let deathRay3Attack = Action(name: "deathRay3Attack", cost: 30)
        deathRay3Attack.setPrecondition(id: enemy_sighted, value: true)
        deathRay3Attack.setPrecondition(id: enemy_dead, value: false)
        deathRay3Attack.setPrecondition(id: enemy_in_avg_range, value: true)
        deathRay3Attack.setPrecondition(id: enemy_is_getting_away, value: true)

        deathRay3Attack.setEffect(id: enemy_dead, value: true)
        actions.append(deathRay3Attack)

        let dead = Action(name: "dead", cost: 30)
        dead.setPrecondition(id: me_dead, value: true)

        dead.setEffect(id: me_dead, value: true)
        actions.append(dead)

    }

    func createInitialState() -> WorldState {
        var initialState = WorldState(name: "initial_state", priority: 0)
        initialState[enemy_dead] = false
        initialState[enemy_sighted] = false
        initialState[enemy_in_range] = false
        initialState[enemy_in_close_range] = false
        initialState[enemy_in_avg_range] = false
        initialState[is_taking_close_hit] = false
        initialState[is_taking_range_hit] = false
        initialState[is_taking_avg_range_hit] = false
        initialState[life_less_than_50_percent] = false
        initialState[enemy_is_getting_away] = false
        initialState[is_time_to_two_claw_attack] = false
        initialState[me_dead] = false

        return initialState
    }

    @Test 
    func shouldPatroll() async throws {

        let expectedActionsNames: [String] = [
            "patrolling",
        ]

        createActions()

        let initialState = createInitialState()
        var goalState = WorldState(name: "State", priority: 100)
        goalState[enemy_sighted] = true

        let planner = Planner()

        let nextActions = planner.plan(fromState: initialState, toGoalState: goalState, actions: actions)

        assert(actions: nextActions, expectedActionsNames: expectedActionsNames)
    }

    @Test 
    func shouldFollowEnemy() async throws {

        let expectedActionsNames: [String] = [
            "bearFollowEnemy",
            "deathRayAttack",
            "bearFollowEnemyToAvgRange",
            "AOEAttack",
            "bearFollowEnemyToCloseRange",
            "clawAttack"
        ]

        createActions()

        var initialState = createInitialState()
        initialState[enemy_sighted] = true

        var goalState = WorldState(name: "State", priority: 100)
        goalState[enemy_dead] = true
        goalState[enemy_in_close_range] = true

        let planner = Planner()

        let nextActions = planner.plan(fromState: initialState, toGoalState: goalState, actions: actions)

        assert(actions: nextActions, expectedActionsNames: expectedActionsNames)
    }

    @Test
    func shouldAttackFromDistance() async throws {

        let expectedActionsNames: [String] = [
            "deathRayAttack",
            "bearFollowEnemyToAvgRange",
            "AOEAttack",
            "bearFollowEnemyToCloseRange",
            "clawAttack"
        ]

        createActions()

        var initialState = createInitialState()
        initialState[enemy_sighted] = true
        initialState[enemy_in_range] = true

        var goalState = WorldState(name: "State", priority: 100)
        goalState[enemy_dead] = true
        goalState[enemy_in_close_range] = true

        let planner = Planner()

        let nextActions = planner.plan(fromState: initialState, toGoalState: goalState, actions: actions)

        assert(actions: nextActions, expectedActionsNames: expectedActionsNames)
    }

    @Test
    func shouldAttackFromAvgDistance() async throws {

        let expectedActionsNames: [String] = [
            "AOEAttack",
            "bearFollowEnemyToCloseRange",
            "clawAttack"
        ]

        createActions()

        var initialState = createInitialState()
        initialState[enemy_sighted] = true
        initialState[enemy_in_avg_range] = true

        var goalState = WorldState(name: "State", priority: 100)
        goalState[enemy_dead] = true
        goalState[enemy_in_close_range] = true

        let planner = Planner()

        let nextActions = planner.plan(fromState: initialState, toGoalState: goalState, actions: actions)

        assert(actions: nextActions, expectedActionsNames: expectedActionsNames)
    }

    @Test
    func shouldAttackFromCloseDistance() async throws {

        let expectedActionsNames: [String] = [
            "bearFollowEnemyToCloseRange",
            "clawAttack"
        ]

        createActions()

        var initialState = createInitialState()
        initialState[enemy_sighted] = true
        initialState[enemy_in_close_range] = true

        var goalState = WorldState(name: "State", priority: 100)
        goalState[enemy_dead] = true

        let planner = Planner()

        let nextActions = planner.plan(fromState: initialState, toGoalState: goalState, actions: actions)

        assert(actions: nextActions, expectedActionsNames: expectedActionsNames)
    }

     @Test
    func shouldAttackFromTwoClawAttack() async throws {

        let expectedActionsNames: [String] = [
            "bearFollowEnemyToCloseRange",
            "getCloseTwoClawAttack"
        ]

        createActions()

        var initialState = createInitialState()
        initialState[enemy_sighted] = true
        initialState[enemy_in_close_range] = true
        initialState[is_time_to_two_claw_attack] = true

        var goalState = WorldState(name: "State", priority: 100)
        goalState[enemy_dead] = true

        let planner = Planner()

        let nextActions = planner.plan(fromState: initialState, toGoalState: goalState, actions: actions)

        assert(actions: nextActions, expectedActionsNames: expectedActionsNames)
    }

}