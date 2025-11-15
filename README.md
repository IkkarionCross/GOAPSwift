# GOAPSwift

A GOAP Implementation in Swift inspired by: [cppGOAP](https://github.com/cpowell/cppGOAP).

## Next steps

1. Debugger: give the option of debug mode to see logs of what is going on;
2. More planner tests with different scenarios;
3. Concurrency model: support swift concurrency. I idented to use this libary in a projet inside [GodotSwift](https://github.com/migueldeicaza/SwiftGodot), so need to see if the support of concurrency is in place;

## GOAP Overview

Goal-Oriented Action Planning (GOAP) is a game AI model that provides autonomy to agents by allowing them to make decisions based on a cost function.
This function traverses a graph of possible actions, evaluating which actions can be executed and how effectively they move the agent from the current world state toward the desired goal state.

By modeling how an agent plans its own path toward a goal, GOAP enhances the illusion that non-playable characters (NPCs) are intelligent, reactive, and plotting their own strategies — making the game world feel more alive.

### The idea is very simple

Take a goal state and a initial world state. Then map all possible actions for an agent to do. give all that to the `planner`. It will run through the available actions, calculating it costs, mesuring their distance to the goal and appliing the actions in the world. Once the world state get`s to the desired state it stops and return the list of actions. A sequence of steps to achieve the desired state.

### The algorithm

This implementation uses the A* (A-Star) algorithm.

- The open list contains available actions to explore.

- The closed list contains actions that are no longer valid or applicable.

The algorithm repeatedly evaluates actions from the open list, expanding possible paths until it finds one that reaches the goal.
Once a valid plan is found, it reconstructs the path from the open list and returns it to the agent for execution.

## Examples

Check the unit tests for examples of how to define actions, goals, and world states, and how to use the planner to generate action plans.