

import Foundation
import Testing

@testable import GOAPSwift

final class GOAPTests {

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

        let scout = Action(name: "scoutSteahly", cost: 250)
        scout.setPrecondition(id: enemy_sighted, value: false)
        scout.setPrecondition(id: weapon_in_hand, value: true)
        
        scout.setEffect(id: enemy_sighted, value: true)
        actions.append(scout)

        let scoutRunning = Action(name: "scoutRunning", cost: 150)
        scoutRunning.setPrecondition(id: enemy_sighted, value: false)
        scoutRunning.setPrecondition(id: weapon_in_hand, value: true)
        
        scoutRunning.setEffect(id: enemy_sighted, value: true)
        actions.append(scoutRunning)

        let closeToGunRange = Action(name: "closeToGunRange", cost: 2)
        closeToGunRange.setPrecondition(id: enemy_sighted, value: true)
        closeToGunRange.setPrecondition(id: enemy_dead, value: false)
        closeToGunRange.setPrecondition(id: enemy_in_range, value: false)
        closeToGunRange.setPrecondition(id: gun_loaded, value: true)
        
        closeToGunRange.setEffect(id: enemy_in_range, value: true)
        actions.append(closeToGunRange)

        let closeToKnifeRange = Action(name: "closeToKnifeRange", cost: 4)
        closeToKnifeRange.setPrecondition(id: enemy_sighted, value: true)
        closeToKnifeRange.setPrecondition(id: enemy_dead, value: false)
        closeToKnifeRange.setPrecondition(id: enemy_in_close_range, value: false)
        closeToKnifeRange.setPrecondition(id: weapon_in_hand, value: true)
        
        closeToKnifeRange.setEffect(id: enemy_in_close_range, value: true)
        actions.append(closeToKnifeRange)

        let loadGun = Action(name: "loadGun", cost: 2)
        loadGun.setPrecondition(id: have_ammo, value: true)
        loadGun.setPrecondition(id: gun_loaded, value: false)
        loadGun.setPrecondition(id: gun_drawn, value: true)

        loadGun.setEffect(id: gun_loaded, value: true)
        loadGun.setEffect(id: have_ammo, value: false)
        actions.append(loadGun)

        let drawGun = Action(name: "drawGun", cost: 1)
        drawGun.setPrecondition(id: inventory_gun, value: true)
        drawGun.setPrecondition(id: weapon_in_hand, value: false)
        drawGun.setPrecondition(id: gun_drawn, value: false)

        drawGun.setEffect(id: gun_drawn, value: true)
        drawGun.setEffect(id: weapon_in_hand, value: true)
        actions.append(drawGun)

        let holsterGun = Action(name: "holsterGun", cost: 1)
        holsterGun.setPrecondition(id: gun_drawn, value: true)
        holsterGun.setPrecondition(id: weapon_in_hand, value: true)

        holsterGun.setEffect(id: gun_drawn, value: false)
        holsterGun.setEffect(id: weapon_in_hand, value: false)
        actions.append(holsterGun)

        let drawKnife = Action(name: "drawKnife", cost: 1)
        drawKnife.setPrecondition(id: inventory_knife, value: true)
        drawKnife.setPrecondition(id: weapon_in_hand, value: false)
        drawKnife.setPrecondition(id: knife_drawn, value: false)

        drawKnife.setEffect(id: knife_drawn, value: true)
        drawKnife.setEffect(id: weapon_in_hand, value: true)
        actions.append(drawKnife)

        let sheathKnife = Action(name: "sheathKnife", cost: 1)
        sheathKnife.setPrecondition(id: weapon_in_hand, value: true)
        sheathKnife.setPrecondition(id: knife_drawn, value: true)

        sheathKnife.setEffect(id: knife_drawn, value: false)
        sheathKnife.setEffect(id: weapon_in_hand, value: false)
        actions.append(sheathKnife)

        let shootEnemy = Action(name: "shootEnemy", cost: 3)
        shootEnemy.setPrecondition(id: enemy_sighted, value: true)
        shootEnemy.setPrecondition(id: enemy_dead, value: false)
        shootEnemy.setPrecondition(id: gun_drawn, value: true)
        shootEnemy.setPrecondition(id: gun_loaded, value: true)
        shootEnemy.setPrecondition(id: enemy_in_range, value: true)

        shootEnemy.setEffect(id: enemy_dead, value: true)
        actions.append(shootEnemy)

        let knifeEnemy = Action(name: "knifeEnemy", cost: 3)
        knifeEnemy.setPrecondition(id: enemy_sighted, value: true)
        knifeEnemy.setPrecondition(id: enemy_dead, value: false)
        knifeEnemy.setPrecondition(id: knife_drawn, value: true)
        knifeEnemy.setPrecondition(id: enemy_in_close_range, value: true)

        knifeEnemy.setEffect(id: enemy_dead, value: true)
        actions.append(knifeEnemy)

        let selfDestruct = Action(name: "selfDestruct", cost: 30)
        selfDestruct.setPrecondition(id: enemy_sighted, value: true)
        selfDestruct.setPrecondition(id: enemy_dead, value: false)
        selfDestruct.setPrecondition(id: enemy_in_range, value: true)

        selfDestruct.setEffect(id: enemy_dead, value: true)
        selfDestruct.setEffect(id: me_dead, value: true)
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
        print("Listing next actions")

        for action in nextActions.reversed() {

            guard expectedActionsNames.contains(action.name) else {
                #expect(Bool(false))
                return
            }
            
            print(action.name)
        }
    }

}