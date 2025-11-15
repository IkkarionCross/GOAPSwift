

import Testing
import Foundation

@testable import GOAPSwift

final class NodeTests {

    @Test
    func testShouldBeLessThanOtherNode() {

        let state = WorldState(name: "oi", priority: 100)

        let n1: NodeGOAP = NodeGOAP(state: state, parentId: 0, cost: 5, costToGoal: 0, action: nil)
        let n2: NodeGOAP = NodeGOAP(state: state, parentId: 0, cost: 10, costToGoal: 0, action: nil)

        #expect(n1 < n2)
    }

    @Test
    func testShouldNOTBeLessThanOtherNode() {

        let state = WorldState(name: "oi", priority: 100)

        let n1: NodeGOAP = NodeGOAP(state: state, parentId: 0, cost: 5, costToGoal: 0, action: nil)
        let n2: NodeGOAP = NodeGOAP(state: state, parentId: 0, cost: 5, costToGoal: 0, action: nil)

        #expect((n1 < n2) == false)
    }

}