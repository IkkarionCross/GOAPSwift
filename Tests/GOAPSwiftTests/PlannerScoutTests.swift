

import Foundation
import Testing

@testable import GOAPSwift

final class PlannerTestsScout: PlannerTestable {

    var actions: [Action] = []

    let enemy_sighted = 0
    let enemy_dead = 1
    let enemy_in_range = 2
    let enemy_in_close_range = 3
    let inventory_knife = 4
    let inventory_gun = 5
    let gun_drawn = 6
    let gun_loaded = 7
    let have_ammo = 8
    let knife_drawn = 9
    let weapon_in_hand = 10
    let me_dead = 11

    func createActions() {

        var scout = Action(name: "scoutSteahly", cost: 250)
        scout.add(precondition: (id: enemy_sighted, value: false))
        scout.add(precondition: (id: weapon_in_hand, value: true))
        
        scout.add(effect: (id: enemy_sighted, value: true))
        actions.append(scout)

        var scoutRunning = Action(name: "scoutRunning", cost: 150)
        scoutRunning.add(precondition: (id: enemy_sighted, value: false))
        scoutRunning.add(precondition: (id: weapon_in_hand, value: true))
        
        scoutRunning.add(effect: (id: enemy_sighted, value: true))
        actions.append(scoutRunning)

        var closeToGunRange = Action(name: "closeToGunRange", cost: 2)
        closeToGunRange.add(precondition: (id: enemy_sighted, value: true))
        closeToGunRange.add(precondition: (id: enemy_dead, value: false))
        closeToGunRange.add(precondition: (id: enemy_in_range, value: false))
        closeToGunRange.add(precondition: (id: gun_loaded, value: true))
        
        closeToGunRange.add(effect: (id: enemy_in_range, value: true))
        actions.append(closeToGunRange)

        var closeToKnifeRange = Action(name: "closeToKnifeRange", cost: 4)
        closeToKnifeRange.add(precondition: (id: enemy_sighted, value: true))
        closeToKnifeRange.add(precondition: (id: enemy_dead, value: false))
        closeToKnifeRange.add(precondition: (id: enemy_in_close_range, value: false))
        closeToKnifeRange.add(precondition: (id: weapon_in_hand, value: true))
        
        closeToKnifeRange.add(effect: (id: enemy_in_close_range, value: true))
        actions.append(closeToKnifeRange)

        var loadGun = Action(name: "loadGun", cost: 2)
        loadGun.add(precondition: (id: have_ammo, value: true))
        loadGun.add(precondition: (id: gun_loaded, value: false))
        loadGun.add(precondition: (id: gun_drawn, value: true))

        loadGun.add(effect: (id: gun_loaded, value: true))
        loadGun.add(effect: (id: have_ammo, value: false))
        actions.append(loadGun)

        var drawGun = Action(name: "drawGun", cost: 1)
        drawGun.add(precondition: (id: inventory_gun, value: true))
        drawGun.add(precondition: (id: weapon_in_hand, value: false))
        drawGun.add(precondition: (id: gun_drawn, value: false))

        drawGun.add(effect: (id: gun_drawn, value: true))
        drawGun.add(effect: (id: weapon_in_hand, value: true))
        actions.append(drawGun)

        var holsterGun = Action(name: "holsterGun", cost: 1)
        holsterGun.add(precondition: (id: gun_drawn, value: true))
        holsterGun.add(precondition: (id: weapon_in_hand, value: true))

        holsterGun.add(effect: (id: gun_drawn, value: false))
        holsterGun.add(effect: (id: weapon_in_hand, value: false))
        actions.append(holsterGun)

        var drawKnife = Action(name: "drawKnife", cost: 1)
        drawKnife.add(precondition: (id: inventory_knife, value: true))
        drawKnife.add(precondition: (id: weapon_in_hand, value: false))
        drawKnife.add(precondition: (id: knife_drawn, value: false))

        drawKnife.add(effect: (id: knife_drawn, value: true))
        drawKnife.add(effect: (id: weapon_in_hand, value: true))
        actions.append(drawKnife)

        var sheathKnife = Action(name: "sheathKnife", cost: 1)
        sheathKnife.add(precondition: (id: weapon_in_hand, value: true))
        sheathKnife.add(precondition: (id: knife_drawn, value: true))

        sheathKnife.add(effect: (id: knife_drawn, value: false))
        sheathKnife.add(effect: (id: weapon_in_hand, value: false))
        actions.append(sheathKnife)

        var shootEnemy = Action(name: "shootEnemy", cost: 3)
        shootEnemy.add(precondition: (id: enemy_sighted, value: true))
        shootEnemy.add(precondition: (id: enemy_dead, value: false))
        shootEnemy.add(precondition: (id: gun_drawn, value: true))
        shootEnemy.add(precondition: (id: gun_loaded, value: true))
        shootEnemy.add(precondition: (id: enemy_in_range, value: true))

        shootEnemy.add(effect: (id: enemy_dead, value: true))
        actions.append(shootEnemy)

        var knifeEnemy = Action(name: "knifeEnemy", cost: 3)
        knifeEnemy.add(precondition: (id: enemy_sighted, value: true))
        knifeEnemy.add(precondition: (id: enemy_dead, value: false))
        knifeEnemy.add(precondition: (id: knife_drawn, value: true))
        knifeEnemy.add(precondition: (id: enemy_in_close_range, value: true))
        knifeEnemy.add(effect: (id: enemy_dead, value: true))
        actions.append(knifeEnemy)

        var selfDestruct = Action(name: "selfDestruct", cost: 30)
        selfDestruct.add(precondition: (id: enemy_sighted, value: true))
        selfDestruct.add(precondition: (id: enemy_dead, value: false))
        selfDestruct.add(precondition: (id: enemy_in_range, value: true))

        selfDestruct.add(effect: (id: enemy_dead, value: true))
        selfDestruct.add(effect: (id: me_dead, value: true))
        actions.append(selfDestruct)

    }

    func createGoalState() -> WorldState {
        var state = WorldState(name: "State", priority: 100)
        state[enemy_dead] = true
        state[me_dead] = false 
        state[weapon_in_hand] = true

        return state
    }

    func createInitialState() -> WorldState {
        var initialState = WorldState(name: "initial_state", priority: 0)
        initialState[enemy_dead] = false
        initialState[enemy_sighted] = false
        initialState[enemy_in_range] = false
        initialState[enemy_in_close_range] = false
        initialState[gun_loaded] = false
        initialState[gun_drawn] = false
        initialState[knife_drawn] = false
        initialState[weapon_in_hand] = false
        initialState[me_dead] = false
        initialState[have_ammo] = true
        initialState[inventory_knife] = true
        initialState[inventory_gun] = true

        return initialState
    }
    
    @Test
    func testShouldRunPlanner() {

        let expectedActionsNames: [String] = [
            "drawGun",
            "loadGun",
            "scoutRunning",
            "closeToGunRange",
            "shootEnemy"
        ]

        createActions()

        let initialState = createInitialState()
        let goalState = createGoalState()

        let planner = Planner()

        let nextActions = planner.plan(fromState: initialState, toGoalState: goalState, actions: actions)
        
        assert(actions: nextActions, expectedActionsNames: expectedActionsNames)
    }

}