

import Foundation
import Testing

@testable import GOAPSwift

final class PlannerBearFighterTests: PlannerTestable {

    var actions: [Action] = []

    enum WorldProperty: Int, WorldPropertyProtocol {
        case enemy_sighted = 0
        case enemy_dead = 1
        case enemy_in_range = 2
        case enemy_in_close_range = 3
        case enemy_in_avg_range = 4
        case is_taking_hit = 5
        case life_less_than_50_percent = 8
        case enemy_is_getting_away = 9
        case is_time_to_two_claw_attack = 10
        case me_dead = 11

        var id: Int {
            return self.rawValue
        }

        var name: String {
            switch self {
            case .enemy_sighted: return "enemy_sighted"
            case .enemy_dead: return "enemy_dead"
            case .enemy_in_range: return "enemy_in_range"
            case .enemy_in_close_range: return "enemy_in_close_range"
            case .enemy_in_avg_range: return "enemy_in_avg_range"
            case .is_taking_hit: return "is_taking_hit"
            case .life_less_than_50_percent: return "life_less_than_50_percent"
            case .enemy_is_getting_away: return "enemy_is_getting_away"
            case .is_time_to_two_claw_attack: return "is_time_to_two_claw_attack"
            case .me_dead: return "me_dead"
            }
        }
    }


    func createActions() {

        var patrolling = Action(name: "patrolling", cost: 250) // Patroll
        patrolling.add(precondition: (id: WorldProperty.enemy_sighted, value: false))
        
        patrolling.add(effect: (id: WorldProperty.enemy_sighted, value: true))
        actions.append(patrolling)

        var bearFollowEnemy = Action(name: "bearFollowEnemy", cost: 70)
        bearFollowEnemy.add(precondition: (id: WorldProperty.enemy_sighted, value: true))
        bearFollowEnemy.add(precondition: (id: WorldProperty.enemy_in_range, value: false))
        
        bearFollowEnemy.add(effect: (id: WorldProperty.enemy_in_range, value: true))
        actions.append(bearFollowEnemy)

        var bearFollowEnemyToAvgRange = Action(name: "bearFollowEnemyToAvgRange", cost: 70)
        bearFollowEnemyToAvgRange.add(precondition: (id: WorldProperty.enemy_sighted, value: true))
        bearFollowEnemyToAvgRange.add(precondition: (id: WorldProperty.enemy_in_avg_range, value: false))
        
        bearFollowEnemyToAvgRange.add(effect: (id: WorldProperty.enemy_in_avg_range, value: true))
        actions.append(bearFollowEnemyToAvgRange)

        var bearFollowEnemyToCloseRange = Action(name: "bearFollowEnemyToCloseRange", cost: 70)
        bearFollowEnemyToCloseRange.add(precondition: (id: WorldProperty.enemy_sighted, value: true))
        bearFollowEnemyToCloseRange.add(precondition: (id: WorldProperty.enemy_in_close_range, value: false))
        
        bearFollowEnemyToCloseRange.add(effect: (id: WorldProperty.enemy_in_close_range, value: true))
        actions.append(bearFollowEnemyToCloseRange)

        var deathRayAttack = Action(name: "deathRayAttack", cost: 5)
        deathRayAttack.add(precondition: (id: WorldProperty.enemy_in_range, value: true))
        deathRayAttack.add(precondition: (id: WorldProperty.enemy_sighted, value: true))
        deathRayAttack.add(precondition: (id: WorldProperty.enemy_dead, value: false))

        deathRayAttack.add(effect: (id: WorldProperty.enemy_dead, value: true))
        actions.append(deathRayAttack)

        var AOEAttack = Action(name: "AOEAttack", cost: 50)
        AOEAttack.add(precondition: (id: WorldProperty.enemy_in_avg_range, value: true))
        AOEAttack.add(precondition: (id: WorldProperty.enemy_dead, value: false))
        AOEAttack.add(precondition: (id: WorldProperty.enemy_sighted, value: true))

        AOEAttack.add(effect: (id: WorldProperty.enemy_dead, value: true))
        actions.append(AOEAttack)

        var clawAttack = Action(name: "clawAttack", cost: 5)
        clawAttack.add(precondition: (id: WorldProperty.enemy_sighted, value: true))
        clawAttack.add(precondition: (id: WorldProperty.enemy_dead, value: false))
        clawAttack.add(precondition: (id: WorldProperty.enemy_in_close_range, value: true))
        clawAttack.add(precondition: (id: WorldProperty.is_time_to_two_claw_attack, value: false))

        clawAttack.add(effect: (id: WorldProperty.enemy_dead, value: true))
        actions.append(clawAttack)

        var counterClawAttack = Action(name: "counterClawAttack", cost: 10)
        counterClawAttack.add(precondition: (id: WorldProperty.enemy_sighted, value: true))
        counterClawAttack.add(precondition: (id: WorldProperty.enemy_dead, value: false))
        counterClawAttack.add(precondition: (id: WorldProperty.enemy_in_close_range, value: true))
        counterClawAttack.add(precondition: (id: WorldProperty.is_taking_hit, value: true))

        counterClawAttack.add(effect: (id: WorldProperty.enemy_dead, value: true))
        actions.append(counterClawAttack)

        var counterDeathRayAttack = Action(name: "counterDeathRayAttack", cost: 10)
        counterDeathRayAttack.add(precondition: (id: WorldProperty.enemy_sighted, value: true))
        counterDeathRayAttack.add(precondition: (id: WorldProperty.enemy_dead, value: false))
        counterDeathRayAttack.add(precondition: (id: WorldProperty.enemy_in_range, value: true))
        counterDeathRayAttack.add(precondition: (id: WorldProperty.is_taking_hit, value: true))

        counterDeathRayAttack.add(effect: (id: WorldProperty.enemy_dead, value: true))
        actions.append(counterDeathRayAttack)

        var counterAOEAttack = Action(name: "counterAOEAttack", cost: 10)
        counterAOEAttack.add(precondition: (id: WorldProperty.enemy_sighted, value: true))
        counterAOEAttack.add(precondition: (id: WorldProperty.enemy_dead, value: false))
        counterAOEAttack.add(precondition: (id: WorldProperty.enemy_in_avg_range, value: true))
        counterAOEAttack.add(precondition: (id: WorldProperty.is_taking_hit, value: true))

        counterAOEAttack.add(effect: (id: WorldProperty.enemy_dead, value: true))
        actions.append(counterAOEAttack)

        var beserkMode = Action(name: "beserkMode", cost: 50)
        beserkMode.add(precondition: (id: WorldProperty.enemy_sighted, value: true))
        beserkMode.add(precondition: (id: WorldProperty.enemy_dead, value: false))
        beserkMode.add(precondition: (id: WorldProperty.life_less_than_50_percent, value: true))

        beserkMode.add(effect: (id: WorldProperty.enemy_dead, value: true))
        actions.append(beserkMode)

        var getCloseTwoClawAttack = Action(name: "getCloseTwoClawAttack", cost: 30)
        getCloseTwoClawAttack.add(precondition: (id: WorldProperty.enemy_sighted, value: true))
        getCloseTwoClawAttack.add(precondition: (id: WorldProperty.enemy_dead, value: false))
        getCloseTwoClawAttack.add(precondition: (id: WorldProperty.enemy_in_close_range, value: true))
        getCloseTwoClawAttack.add(precondition: (id: WorldProperty.is_time_to_two_claw_attack, value: true))

        getCloseTwoClawAttack.add(effect: (id: WorldProperty.enemy_dead, value: true))
        actions.append(getCloseTwoClawAttack)

        var deathRay3Attack = Action(name: "deathRay3Attack", cost: 30)
        deathRay3Attack.add(precondition: (id: WorldProperty.enemy_sighted, value: true))
        deathRay3Attack.add(precondition: (id: WorldProperty.enemy_dead, value: false))
        deathRay3Attack.add(precondition: (id: WorldProperty.enemy_in_avg_range, value: true))
        deathRay3Attack.add(precondition: (id: WorldProperty.enemy_in_close_range, value: true))
        deathRay3Attack.add(precondition: (id: WorldProperty.enemy_in_range, value: true))
        deathRay3Attack.add(precondition: (id: WorldProperty.enemy_is_getting_away, value: true))

        deathRay3Attack.add(effect: (id: WorldProperty.enemy_dead, value: true))
        actions.append(deathRay3Attack)

        var dead = Action(name: "dead", cost: 30)
        dead.add(precondition: (id: WorldProperty.me_dead, value: true))

        dead.add(effect: (id: WorldProperty.me_dead, value: true))
        actions.append(dead)

    }

    func createInitialState() -> WorldState {
        var initialState = WorldState(name: "initial_state", priority: 0)
        initialState[WorldProperty.enemy_dead] = false
        initialState[WorldProperty.enemy_sighted] = false
        initialState[WorldProperty.enemy_in_range] = false
        initialState[WorldProperty.enemy_in_close_range] = false
        initialState[WorldProperty.enemy_in_avg_range] = false
        initialState[WorldProperty.is_taking_hit] = false
        initialState[WorldProperty.life_less_than_50_percent] = false
        initialState[WorldProperty.enemy_is_getting_away] = false
        initialState[WorldProperty.is_time_to_two_claw_attack] = false
        initialState[WorldProperty.me_dead] = false

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
        goalState[WorldProperty.enemy_sighted] = true

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
        initialState[WorldProperty.enemy_sighted] = true

        var goalState = WorldState(name: "State", priority: 100)
        goalState[WorldProperty.enemy_dead] = true
        goalState[WorldProperty.enemy_in_close_range] = true

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
        initialState[WorldProperty.enemy_sighted] = true
        initialState[WorldProperty.enemy_in_range] = true

        var goalState = WorldState(name: "State", priority: 100)
        goalState[WorldProperty.enemy_dead] = true
        goalState[WorldProperty.enemy_in_close_range] = true

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
        initialState[WorldProperty.enemy_sighted] = true
        initialState[WorldProperty.enemy_in_avg_range] = true

        var goalState = WorldState(name: "State", priority: 100)
        goalState[WorldProperty.enemy_dead] = true
        goalState[WorldProperty.enemy_in_close_range] = true

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
        initialState[WorldProperty.enemy_sighted] = true
        initialState[WorldProperty.enemy_in_close_range] = true

        var goalState = WorldState(name: "State", priority: 100)
        goalState[WorldProperty.enemy_dead] = true

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
        initialState[WorldProperty.enemy_sighted] = true
        initialState[WorldProperty.enemy_in_close_range] = true
        initialState[WorldProperty.is_time_to_two_claw_attack] = true

        var goalState = WorldState(name: "State", priority: 100)
        goalState[WorldProperty.enemy_dead] = true

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
        initialState[WorldProperty.enemy_sighted] = true
        initialState[WorldProperty.enemy_in_close_range] = true
        initialState[WorldProperty.life_less_than_50_percent] = true

        var goalState = WorldState(name: "State", priority: 100)
        goalState[WorldProperty.enemy_dead] = true

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
        initialState[WorldProperty.enemy_sighted] = true
        initialState[WorldProperty.enemy_in_range] = true
        initialState[WorldProperty.life_less_than_50_percent] = true

        var goalState = WorldState(name: "State", priority: 100)
        goalState[WorldProperty.enemy_dead] = true

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
        initialState[WorldProperty.enemy_sighted] = true
        initialState[WorldProperty.enemy_in_avg_range] = true
        initialState[WorldProperty.life_less_than_50_percent] = true

        var goalState = WorldState(name: "State", priority: 100)
        goalState[WorldProperty.enemy_dead] = true

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
        initialState[WorldProperty.enemy_sighted] = true
        initialState[WorldProperty.enemy_in_close_range] = true
        initialState[WorldProperty.is_taking_hit] = true

        var goalState = WorldState(name: "State", priority: 100)
        goalState[WorldProperty.enemy_dead] = true

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
        initialState[WorldProperty.enemy_sighted] = true
        initialState[WorldProperty.enemy_in_avg_range] = true
        initialState[WorldProperty.is_taking_hit] = true

        var goalState = WorldState(name: "State", priority: 100)
        goalState[WorldProperty.enemy_dead] = true

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
        initialState[WorldProperty.enemy_sighted] = true
        initialState[WorldProperty.enemy_in_range] = true
        initialState[WorldProperty.is_taking_hit] = true

        var goalState = WorldState(name: "State", priority: 100)
        goalState[WorldProperty.enemy_dead] = true

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
        initialState[WorldProperty.enemy_sighted] = true
        initialState[WorldProperty.enemy_in_range] = true
        initialState[WorldProperty.enemy_is_getting_away] = true

        var goalState = WorldState(name: "State", priority: 100)
        goalState[WorldProperty.enemy_dead] = true

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
        initialState[WorldProperty.enemy_sighted] = true
        initialState[WorldProperty.enemy_in_close_range] = true
        initialState[WorldProperty.enemy_is_getting_away] = true

        var goalState = WorldState(name: "State", priority: 100)
        goalState[WorldProperty.enemy_dead] = true

        let planner = Planner()

        let nextActions = planner.plan(fromState: initialState, toGoalState: goalState, actions: actions)

        assert(actions: nextActions, expectedActionsNames: expectedActionsNames)
    }

}