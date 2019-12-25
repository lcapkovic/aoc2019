//
//  Day18.swift
//  AdventOfCode2019
//
//  Created by Lukas Capkovic on 17/12/2019.
//  Copyright © 2019 Lukas Capkovic. All rights reserved.
//

import Foundation

class Day18b: Day {
    static let dirs = [(0,1), (0,-1), (1,0), (-1,0)]
    static var locs = [String.Element: (Int, Int)]()
    
    struct Pos: Hashable {
        var row: Int
        var col: Int
    }
    
    struct Entry: Hashable {
        var c: Character
        var keys: Set<Character>
    }
    
    static func part1(_ input: String) -> String {
        let map = input.trimmingCharacters(in: .newlines)
            .components(separatedBy: .newlines)
            .map { Array($0) }
                
        var distMap = [Character: [Character: Int]]()
        var keyCount = 0
        
        for row in 0..<map.count {
            for col in 0..<map[0].count {
                let char = map[row][col]
                if char == "." || char == "#" || distMap.keys.contains(char) {
                    continue
                }
                
                if char.isLowercase {
                    keyCount += 1
                }
                
                // BFS from char
                let pos = Pos(row: row, col: col)
                var vis = Set<Pos>()
                var next = [[pos],[]]
                vis.insert(pos)
                var ptr = 0
                var steps = 0
                distMap[char] = [Character: Int]()
                                
                while next[ptr].count > 0 {
                    let nextPtr = (ptr + 1) % 2
                    for n in next[ptr] {
                        for dir in dirs {
                            let newPos = Pos(row: n.row + dir.0, col: n.col + dir.1)
                            
                            if newPos.row >= 0,
                            newPos.col >= 0,
                            newPos.row < map.count,
                            newPos.col < map[0].count,
                            !vis.contains(newPos){
                                let c = map[newPos.row][newPos.col]
                                
                                if c.isLetter {
                                    distMap[char]![c] = steps + 1
                                } else if c == "." || c == "@" {
                                    next[nextPtr].append(newPos)
                                    vis.insert(newPos)
                                }
                            }
                        }
                    }
                    next[ptr] = []
                    ptr = nextPtr
                    steps += 1
                }
            }
        }
        
        // BFS from @
        let first = Entry(c: "@", keys: Set<Character>())
        var next = [Set<Entry>(), Set<Entry>()]
        next[0].insert(first)
        
        var steps = [Entry: Int]()
        steps[first] = 0
        var ptr = 0
        
        while next[ptr].count > 0 {
            let nextPtr = (ptr + 1) % 2
            
            var finished = false
            for n in next[ptr] {
                let reachable = distMap[n.c]!.keys
                
                for r in reachable {
                    let dist = distMap[n.c]![r]!
                    var toAdd = Entry(c: r, keys: n.keys)
                    var add = false
                    if r.isUppercase, n.keys.contains(Character(r.lowercased())) {
                        toAdd = Entry(c: r, keys: n.keys)
                        add = true
                    } else if r.isLowercase {
                        toAdd.keys.insert(r)
                        if toAdd.keys.count == keyCount {
                            finished = true
                        }
                        add = true
                    }
                    
                    if add {
                        next[nextPtr].insert(toAdd)
                        steps[toAdd] = min(steps[toAdd] ?? 10000, dist + steps[n]!)
                    }
                    
//                    if toAdd == Entry(c: "c", keys: Set(["a", "c"])) {
//                        print(dist)
//                        print(n)
//                        print(r)
//                        print(steps[toAdd])
//                    }
                        
                    
                }
            }
            if finished {
                var minSteps = 10000
                for key in steps.keys {
                    if key.keys.count == keyCount {
                        minSteps = min(minSteps, steps[key]!)
                    }
                }
                
                return String(minSteps)
            }
            next[ptr] = []
//            print(next[nextPtr])
//            print(steps)
            ptr = nextPtr
        }
        return ""
    }
    
    static func part2(_ input: String) -> String {
        return ""
    }
}
