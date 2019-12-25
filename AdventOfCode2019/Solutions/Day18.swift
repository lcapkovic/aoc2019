//
//  Day18.swift
//  AdventOfCode2019
//
//  Created by Lukas Capkovic on 19/12/2019.
//  Copyright © 2019 Lukas Capkovic. All rights reserved.
//

import Foundation

class Day18: Day {
    
    static let dirs = [(0,1), (0,-1), (1,0), (-1,0)]

    struct Pos: Hashable {
        var row: Int
        var col: Int
    }
    
    struct State: Hashable {
        var pos: Character
        var keys: Set<Character>
    }
    
    struct State2: Hashable {
        var c1: Character
        var c2: Character
        var c3: Character
        var c4: Character
        var keys: Set<Character>
    }
    
    static func part1(_ input: String) -> String {
        let map = input.trimmingCharacters(in: .newlines)
        .components(separatedBy: .newlines)
        .map { Array($0) }
        
        var distMap = [Character: [Character: (Int, Set<Character>)]]()
        var keyCount = 0
        
        for row in 0..<map.count {
            for col in 0..<map[0].count {
                let start = map[row][col]
                if start == "." || start == "#" || distMap.keys.contains(start) || start.isUppercase {
                    continue
                }
                
                if start.isLowercase {
                    keyCount += 1
                }
                
                // BFS from start
                let pos = Pos(row: row, col: col)
                var next = [[(pos, Set<Character>())],[]]
                
                var ptr = 0
                var steps = 0
                
                distMap[start] = [Character: (Int, Set<Character>)]()
                var vis = Set<Pos>()
                vis.insert(pos)
                                
                while next[ptr].count > 0 {
                    let nextPtr = (ptr + 1) % 2
                    for state in next[ptr] {
                        for dir in dirs {
                            let newPos = Pos(row: state.0.row + dir.0, col: state.0.col + dir.1)
                            
                            if newPos.row >= 0,
                            newPos.col >= 0,
                            newPos.row < map.count,
                            newPos.col < map[0].count,
                            !vis.contains(newPos){
                                let c = map[newPos.row][newPos.col]
                                
                                var addDoor = false
                                
                                if c.isUppercase {
                                    addDoor = true
                                } else if c.isLowercase {
                                    distMap[start]![c] = (steps + 1, state.1)
                                }
                                
                                if c != "#" {
                                    next[nextPtr].append((newPos, state.1.union((addDoor ? [c] : []))))
                                    vis.insert(newPos)
                                }
                            }
                        }
                    }
                    next[ptr].removeAll(keepingCapacity: true)
                    ptr = nextPtr
                    steps += 1
                }
            }
        }
                        
        var deque = Deque<State>()
        var stepsToReach = [State: Int]()
        
        deque.enqueue(State(pos: "@", keys: Set<Character>()))
        stepsToReach[State(pos: "@", keys: Set<Character>())] = 0
        
        var minSteps = 1000000
        
        while !deque.isEmpty {
            let state = deque.dequeue()!
            let keys = state.keys
            
            if keys.count == keyCount {
                minSteps = min(minSteps, stepsToReach[state]!)
            }
            
            for dest in distMap[state.pos]! {
                var next = false
                for key in dest.value.1 {
                    if !keys.contains(key) {
                        next = true
                        break
                    }
                }
                
                if next {
                    continue
                }
                
                let c = dest.key
                
                if state.keys.contains(Character(c.uppercased())) {
                    continue
                }
                
                let dist = dest.value.0
                var newKeys = keys
                newKeys.insert(Character(c.uppercased()))
                let newState = State(pos: c, keys: newKeys)
                
                if stepsToReach.keys.contains(newState) {
                    stepsToReach[newState] = min(stepsToReach[newState]!, dist + stepsToReach[state]!)
                } else {
                    deque.enqueue(newState)
                    stepsToReach[newState] = dist + stepsToReach[state]!
                }
            }
        }

        return String(minSteps)
    }
    
    static func part2(_ input: String) -> String {
        var map = input.trimmingCharacters(in: .newlines)
        .components(separatedBy: .newlines)
        .map { Array($0) }
        
        map[39][39] = "1"
        map[39][40] = "#"
        map[39][41] = "2"
        
        map[40][39] = "#"
        map[40][40] = "#"
        map[40][41] = "#"
        
        map[41][39] = "3"
        map[41][40] = "#"
        map[41][41] = "4"

        var distMap = [Character: [Character: (Int, Set<Character>)]]()
        var keyCount = 0
        
        for row in 0..<map.count {
            for col in 0..<map[0].count {
                let start = map[row][col]
                if start == "." || start == "#" || distMap.keys.contains(start) {
                    continue
                }
                
                if start.isLowercase {
                    keyCount += 1
                }
                
                // BFS from start
                let pos = Pos(row: row, col: col)
                var next = [[(pos, Set<Character>())],[]]
                
                var ptr = 0
                var steps = 0
                
                distMap[start] = [Character: (Int, Set<Character>)]()
                var vis = Set<Pos>()
                vis.insert(pos)
                                
                while next[ptr].count > 0 {
                    let nextPtr = (ptr + 1) % 2
                    for state in next[ptr] {
                        for dir in dirs {
                            let newPos = Pos(row: state.0.row + dir.0, col: state.0.col + dir.1)
                            
                            if newPos.row >= 0,
                            newPos.col >= 0,
                            newPos.row < map.count,
                            newPos.col < map[0].count,
                            !vis.contains(newPos){
                                let c = map[newPos.row][newPos.col]
                                
                                var addDoor = false
                                
                                if c.isUppercase {
                                    addDoor = true
                                } else if c.isLowercase {
                                    distMap[start]![c] = (steps + 1, state.1)
                                }
                                
                                if c != "#" {
                                    next[nextPtr].append((newPos, state.1.union((addDoor ? [c] : []))))
                                    vis.insert(newPos)
                                }
                            }
                        }
                    }
                    next[ptr].removeAll(keepingCapacity: true)
                    ptr = nextPtr
                    steps += 1
                }
            }
        }
                        
        var deque = Deque<State2>()
        var stepsToReach = [State2: Int]()

        let start = State2(c1: "1", c2: "2", c3: "3", c4: "4", keys: Set<Character>())
        deque.enqueue(start)
        stepsToReach[start] = 0
        
        var minSteps = 1000000

        while !deque.isEmpty {
            let state = deque.dequeue()!
            let keys = state.keys

            if keys.count == keyCount {
                minSteps = min(minSteps, stepsToReach[state]!)
                continue
            }
            
            for ix in 0..<4 {
                let mover = [state.c1, state.c2, state.c3, state.c4][ix]
                for dest in distMap[mover]! {
                    var next = false
                    for key in dest.value.1 {
                        if !keys.contains(key) {
                            next = true
                            break
                        }
                    }
                    
                    let c = dest.key

                    if next || state.keys.contains(Character(c.uppercased())) {
                        continue
                    }
                    
                    let dist = dest.value.0
                    var newKeys = keys
                    newKeys.insert(Character(c.uppercased()))
                    var newState: State2
                    
                    if ix == 0 {
                        newState = State2(c1: c, c2: state.c2, c3: state.c3, c4: state.c4, keys: newKeys)
                    } else if ix == 1 {
                        newState = State2(c1: state.c1, c2: c, c3: state.c3, c4: state.c4, keys: newKeys)
                    } else if ix == 2 {
                        newState = State2(c1: state.c1, c2: state.c2, c3: c, c4: state.c4, keys: newKeys)
                    } else {
                        newState = State2(c1: state.c1, c2: state.c2, c3: state.c3, c4: c, keys: newKeys)
                    }

                    if stepsToReach.keys.contains(newState) {
                        stepsToReach[newState] = min(stepsToReach[newState]!, dist + stepsToReach[state]!)
                    } else {
                        deque.enqueue(newState)
                        stepsToReach[newState] = dist + stepsToReach[state]!
                    }
                }
            }

        }

        return String(minSteps)
    }
}
