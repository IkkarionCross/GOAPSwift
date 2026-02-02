

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
    let is_taking_hit = 5
    let life_less_than_50_percent = 8
    let enemy_is_getting_away = 9
    let is_time_to_two_claw_attack = 10
    let me_dead = 11

    func createActions() {

        var patrolling = Action(name: "patrolling", cost: 250) // Patroll
        patrolling.add(precondition: (id: enemy_sighted, value: false))
        
        patrolling.add(effect: (id: enemy_sighted, value: true))
        actions.append(patrolling)

        var bearFollowEnemy = Action(name: "bearFollowEnemy", cost: 70)
        bearFollowEnemy.add(precondition: (id: enemy_sighted, value: true))
        bearFollowEnemy.add(precondition: (id: enemy_in_range, value: false))
        
        bearFollowEnemy.add(effect: (id: enemy_in_range, value: true))
        actions.append(bearFollowEnemy)

        var bearFollowEnemyToAvgRange = Action(name: "bearFollowEnemyToAvgRange", cost: 70)
        bearFollowEnemyToAvgRange.add(precondition: (id: enemy_sighted, value: true))
        bearFollowEnemyToAvgRange.add(precondition: (id: enemy_in_avg_range, value: false))
        
        bearFollowEnemyToAvgRange.add(effect: (id: enemy_in_avg_range, value: true))
        actions.append(bearFollowEnemyToAvgRange)

        var bearFollowEnemyToCloseRange = Action(name: "bearFollowEnemyToCloseRange", cost: 70)
        bearFollowEnemyToCloseRange.add(precondition: (id: enemy_sighted, value: true))
        bearFollowEnemyToCloseRange.add(precondition: (id: enemy_in_close_range, value: false))
        
        bearFollowEnemyToCloseRange.add(effect: (id: enemy_in_close_range, value: true))
        actions.append(bearFollowEnemyToCloseRange)

        var deathRayAttack = Action(name: "deathRayAttack", cost: 5)
        deathRayAttack.add(precondition: (id: enemy_in_range, value: true))
        deathRayAttack.add(precondition: (id: enemy_sighted, value: true))
        deathRayAttack.add(precondition: (id: enemy_dead, value: false))

        deathRayAttack.add(effect: (id: enemy_dead, value: true))
        actions.append(deathRayAttack)

        var AOEAttack = Action(name: "AOEAttack", cost: 50)
        AOEAttack.add(precondition: (id: enemy_in_avg_range, value: true))
        AOEAttack.add(precondition: (id: enemy_dead, value: false))
        AOEAttack.add(precondition: (id: enemy_sighted, value: true))

        AOEAttack.add(effect: (id: enemy_dead, value: true))
        actions.append(AOEAttack)

        var clawAttack = Action(name: "clawAttack", cost: 5)
        clawAttack.add(precondition: (id: enemy_sighted, value: true))
        clawAttack.add(precondition: (id: enemy_dead, value: false))
        clawAttack.add(precondition: (id: enemy_in_close_range, value: true))
        clawAttack.add(precondition: (id: is_time_to_two_claw_attack, value: false))

        clawAttack.add(effect: (id: enemy_dead, value: true))
        actions.append(clawAttack)

        var counterClawAttack = Action(name: "counterClawAttack", cost: 10)
        counterClawAttack.add(precondition: (id: enemy_sighted, value: true))
        counterClawAttack.add(precondition: (id: enemy_dead, value: false))
        counterClawAttack.add(precondition: (id: enemy_in_close_range, value: true))
        counterClawAttack.add(precondition: (id: is_taking_hit, value: true))

        counterClawAttack.add(effect: (id: enemy_dead, value: true))
        actions.append(counterClawAttack)

        var counterDeathRayAttack = Action(name: "counterDeathRayAttack", cost: 10)
        counterDeathRayAttack.add(precondition: (id: enemy_sighted, value: true))
        counterDeathRayAttack.add(precondition: (id: enemy_dead, value: false))
        counterDeathRayAttack.add(precondition: (id: enemy_in_range, value: true))
        counterDeathRayAttack.add(precondition: (id: is_taking_hit, value: true))

        counterDeathRayAttack.add(effect: (id: enemy_dead, value: true))
        actions.append(counterDeathRayAttack)

        var counterAOEAttack = Action(name: "counterAOEAttack", cost: 10)
        counterAOEAttack.add(precondition: (id: enemy_sighted, value: true))
        counterAOEAttack.add(precondition: (id: enemy_dead, value: false))
        counterAOEAttack.add(precondition: (id: enemy_in_avg_range, value: true))
        counterAOEAttack.add(precondition: (id: is_taking_hit, value: true))

        counterAOEAttack.add(effect: (id: enemy_dead, value: true))
        actions.append(counterAOEAttack)

        var beserkMode = Action(name: "beserkMode", cost: 50)
        beserkMode.add(precondition: (id: enemy_sighted, value: true))
        beserkMode.add(precondition: (id: enemy_dead, value: false))
        beserkMode.add(precondition: (id: life_less_than_50_percent, value: true))

        beserkMode.add(effect: (id: enemy_dead, value: true))
        actions.append(beserkMode)

        var getCloseTwoClawAttack = Action(name: "getCloseTwoClawAttack", cost: 30)
        getCloseTwoClawAttack.add(precondition: (id: enemy_sighted, value: true))
        getCloseTwoClawAttack.add(precondition: (id: enemy_dead, value: false))
        getCloseTwoClawAttack.add(precondition: (id: enemy_in_close_range, value: true))
        getCloseTwoClawAttack.add(precondition: (id: is_time_to_two_claw_attack, value: true))

        getCloseTwoClawAttack.add(effect: (id: enemy_dead, value: true))
        actions.append(getCloseTwoClawAttack)

        var deathRay3Attack = Action(name: "deathRay3Attack", cost: 30)
        deathRay3Attack.add(precondition: (id: enemy_sighted, value: true))
        deathRay3Attack.add(precondition: (id: enemy_dead, value: false))
        deathRay3Attack.add(precondition: (id: enemy_in_avg_range, value: true))
        deathRay3Attack.add(precondition: (id: enemy_in_close_range, value: true))
        deathRay3Attack.add(precondition: (id: enemy_in_range, value: true))
        deathRay3Attack.add(precondition: (id: enemy_is_getting_away, value: true))

        deathRay3Attack.add(effect: (id: enemy_dead, value: true))
        actions.append(deathRay3Attack)

        var dead = Action(name: "dead", cost: 30)
        dead.add(precondition: (id: me_dead, value: true))

        dead.add(effect: (id: me_dead, value: true))
        actions.append(dead)

    }

    func createInitialState() -> WorldState {
        var initialState = WorldState(name: "initial_state", priority: 0)
        initialState[enemy_dead] = false
        initialState[enemy_sighted] = false
        initialState[enemy_in_range] = false
        initialState[enemy_in_close_range] = false
        initialState[enemy_in_avg_range] = false
        initialState[is_taking_hit] = false
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

    @Test
    func shouldGoBeserkModeCloseRange() async throws {

        let expectedActionsNames: [String] = [
            "beserkMode",
            "clawAttack"
        ]

        createActions()

        var initialState = createInitialState()
        initialState[enemy_sighted] = true
        initialState[enemy_in_close_range] = true
        initialState[life_less_than_50_percent] = true

        var goalState = WorldState(name: "State", priority: 100)
        goalState[enemy_dead] = true

        let planner = Planner()

        let nextActions = planner.plan(fromState: initialState, toGoalState: goalState, actions: actions)

        assert(actions: nextActions, expectedActionsNames: expectedActionsNames)
    }

    @Test
    func shouldGoBeserkModeFromDistance() async throws {

        let expectedActionsNames: [String] = [
            "beserkMode",
            "deathRayAttack"
        ]

        createActions()

        var initialState = createInitialState()
        initialState[enemy_sighted] = true
        initialState[enemy_in_range] = true
        initialState[life_less_than_50_percent] = true

        var goalState = WorldState(name: "State", priority: 100)
        goalState[enemy_dead] = true

        let planner = Planner()

        let nextActions = planner.plan(fromState: initialState, toGoalState: goalState, actions: actions)

        assert(actions: nextActions, expectedActionsNames: expectedActionsNames)
    }

    @Test
    func shouldGoBeserkModeAvgDistance() async throws {

        let expectedActionsNames: [String] = [
            "beserkMode",
            "AOEAttack"
        ]

        createActions()

        var initialState = createInitialState()
        initialState[enemy_sighted] = true
        initialState[enemy_in_avg_range] = true
        initialState[life_less_than_50_percent] = true

        var goalState = WorldState(name: "State", priority: 100)
        goalState[enemy_dead] = true

        let planner = Planner()

        let nextActions = planner.plan(fromState: initialState, toGoalState: goalState, actions: actions)

        assert(actions: nextActions, expectedActionsNames: expectedActionsNames)
    }

    @Test
    func shouldCounterCloseRangeAttack() async throws {

        let expectedActionsNames: [String] = [
            "clawAttack",
            "counterClawAttack",
        ]

        createActions()

        var initialState = createInitialState()
        initialState[enemy_sighted] = true
        initialState[enemy_in_close_range] = true
        initialState[is_taking_hit] = true

        var goalState = WorldState(name: "State", priority: 100)
        goalState[enemy_dead] = true

        let planner = Planner()

        let nextActions = planner.plan(fromState: initialState, toGoalState: goalState, actions: actions)

        assert(actions: nextActions, expectedActionsNames: expectedActionsNames)
    }

    @Test
    func shouldCounterAVGRangeAttack() async throws {

        let expectedActionsNames: [String] = [
            "counterAOEAttack",
        ]

        createActions()

        var initialState = createInitialState()
        initialState[enemy_sighted] = true
        initialState[enemy_in_avg_range] = true
        initialState[is_taking_hit] = true

        var goalState = WorldState(name: "State", priority: 100)
        goalState[enemy_dead] = true

        let planner = Planner()

        let nextActions = planner.plan(fromState: initialState, toGoalState: goalState, actions: actions)

        assert(actions: nextActions, expectedActionsNames: expectedActionsNames)
    }

    @Test
    func shouldCounterRangeAttack() async throws {

        let expectedActionsNames: [String] = [
            "deathRayAttack",
            "counterDeathRayAttack",
        ]

        createActions()

        var initialState = createInitialState()
        initialState[enemy_sighted] = true
        initialState[enemy_in_range] = true
        initialState[is_taking_hit] = true

        var goalState = WorldState(name: "State", priority: 100)
        goalState[enemy_dead] = true

        let planner = Planner()

        let nextActions = planner.plan(fromState: initialState, toGoalState: goalState, actions: actions)

        assert(actions: nextActions, expectedActionsNames: expectedActionsNames)
    }

    @Test
    func shouldAttackingGettingWayEnemy() async throws {

        let expectedActionsNames: [String] = [
            "deathRayAttack",
            "deathRay3Attack",
        ]

        createActions()

        var initialState = createInitialState()
        initialState[enemy_sighted] = true
        initialState[enemy_in_range] = true
        initialState[enemy_is_getting_away] = true

        var goalState = WorldState(name: "State", priority: 100)
        goalState[enemy_dead] = true

        let planner = Planner()

        let nextActions = planner.plan(fromState: initialState, toGoalState: goalState, actions: actions)

        assert(actions: nextActions, expectedActionsNames: expectedActionsNames)
    }

    @Test
    func shouldAttackGettingWayEnemyClose() async throws {

        let expectedActionsNames: [String] = [
            "clawAttack",
            "getCloseTwoClawAttack",
            "deathRay3Attack",
        ]

        createActions()

        var initialState = createInitialState()
        initialState[enemy_sighted] = true
        initialState[enemy_in_close_range] = true
        initialState[enemy_is_getting_away] = true

        var goalState = WorldState(name: "State", priority: 100)
        goalState[enemy_dead] = true

        let planner = Planner()

        let nextActions = planner.plan(fromState: initialState, toGoalState: goalState, actions: actions)

        assert(actions: nextActions, expectedActionsNames: expectedActionsNames)
    }

}