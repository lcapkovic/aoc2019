//
//  Day3.swift
//  AdventOfCode2019
//
//  Created by Lukas Capkovic on 02/12/2019.
//  Copyright © 2019 Lukas Capkovic. All rights reserved.
//

import Foundation

class Day3: Day {
    
    static let dirs: [Character: (Int, Int)] = ["U": (0,1), "R": (1,0), "D": (0,-1), "L": (-1,0)]
    
    struct Pos: Hashable {
        var x: Int
        var y: Int
    }
    
    static func part1(_ input: String) -> String {
        let lines = input.trimmingCharacters(in: .newlines)
            .components(separatedBy: .newlines)
            .map { $0.components(separatedBy: .punctuationCharacters) }
        
        let minDist = allIntersections(wire1: lines[0], wire2: lines[1]).map { abs($0.x) + abs($0.y) }.min()
        
        return String(minDist ?? 0)
    }
    
    static func part2(_ input: String) -> String {
        let lines = input.trimmingCharacters(in: .newlines)
            .components(separatedBy: .newlines)
            .map { $0.components(separatedBy: .punctuationCharacters) }
        
        let inters = allIntersections(wire1: lines[0], wire2: lines[1])

        let steps0 = stepsToReach(intersections: inters, cmds: lines[0])
        let steps1 = stepsToReach(intersections: inters, cmds: lines[1])
        
        let minSteps = zip(steps0, steps1).map { $0 + $1 }.min()
        
        return String(minSteps ?? 0)
    }
    
    static func allIntersections(wire1: [String], wire2: [String]) -> [Pos] {
        var curPos = (0,0)
        
        var visited = Set<Pos>()
        
        for cmd in wire1 {
            let dir = cmd.first!
            let dist = Int(String(cmd.dropFirst()))!
            let dirVec = dirs[dir]!
            
            for _ in 0..<dist {
                curPos = (curPos.0 + dirVec.0, curPos.1 + dirVec.1)
                visited.insert(Pos(x: curPos.0, y: curPos.1))
            }
        }
        
        return intersections(of: wire2, visited: visited)
    }
    
    static func intersections(of wire: [String], visited: Set<Pos>) -> [Pos] {
        var curPos = Pos(x: 0, y: 0)
        var inters = Set<Pos>()
        
        for cmd in wire {
            let dir = cmd.first!
            let dist = Int(String(cmd.dropFirst()))!
            let dirVec = dirs[dir]!
            
            for _ in 0..<dist {
                curPos.x = curPos.x + dirVec.0
                curPos.y = curPos.y + dirVec.1
                
                if visited.contains(curPos) {
                    inters.insert(curPos)
                }
            }
        }
        
        return Array(inters)
    }
    
    static func stepsToReach(intersections: [Pos], cmds: [String]) -> [Int] {
        var curPos = Pos(x: 0, y: 0)
        var steps = 0
        var visited = [Pos]()
        var allSteps = Array(repeating: 0, count: intersections.count)
                        
        for cmd in cmds {
            let dir = cmd.first!
            let dist = Int(String(cmd.dropFirst()))!
            let dirVec = dirs[dir]!
            
            for _ in 0..<dist {
                curPos.x = curPos.x + dirVec.0
                curPos.y = curPos.y + dirVec.1
                steps += 1
                
                if intersections.contains(curPos) && !visited.contains(curPos) {
                    visited.append(curPos)
                    allSteps[intersections.firstIndex(of: curPos)!] = steps
                }
            }
        }
        
        return allSteps
    }
}
