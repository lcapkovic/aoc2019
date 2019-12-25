//
//  Day20.swift
//  AdventOfCode2019
//
//  Created by Lukas Capkovic on 21/12/2019.
//  Copyright © 2019 Lukas Capkovic. All rights reserved.
//

import Foundation

class Day20: Day {
    static let dirs = [(0,1), (1,0), (0,-1), (-1,0)]
    
    struct Pos: Hashable {
        var row: Int
        var col: Int
    }
    
    struct Pos2: Hashable {
        var row: Int
        var col: Int
        var level: Int
    }
    
    static func part1(_ input: String) -> String {
        var map = input.trimmingCharacters(in: .newlines)
        .components(separatedBy: .newlines)
        .map { Array($0) }
                
        let width = map.map { $0.count }.max()!
        
        map = [Array(repeating: Character(" "), count: width)]
            + map
            + [Array(repeating: Character(" "), count: width)]
        
        for i in 0..<map.count {
            map[i] = [" "] + map[i] + Array(repeating: " ", count: width - map[i].count) + [" "]
        }
        
        var pMap = Array(repeating: Array(repeating: 0, count: map[0].count), count: map.count)
        var portalId = 2
        var portalMap = [Int: [(Int, Int)]]()
        var nameMapping = [Set<Character>: Int]()
        var bl = Set<Int>()
        for iRow in 1..<map.count-1 {
            for iCol in 1..<map[0].count-1 {
                if bl.contains(iRow * 1000 + iCol) {
                    continue
                }
                
                let val = map[iRow][iCol]
                if val == "." {
                    pMap[iRow][iCol] = 1
                } else if val.isLetter {
                    
                    for dir in dirs {
                        if map[iRow + dir.0][iCol + dir.1] == ".",
                        map[iRow - dir.0][iCol - dir.1].isLetter {
                            let letterSet = Set<Character>([val, map[iRow - dir.0][iCol - dir.1]])
                            
                            if !bl.contains((iRow - dir.0) * 1000 + (iCol - dir.1)) {
                                bl.insert((iRow - dir.0) * 1000 + (iCol - dir.1))
                                bl.insert((iRow + dir.0) * 1000 + (iCol + dir.1))
                            }
                            
                            if let id = nameMapping[letterSet] {
                                pMap[iRow + dir.0][iCol + dir.1] = id
                                portalMap[id]!.append((iRow + dir.0, iCol + dir.1))
                            } else {
                                nameMapping[letterSet] = portalId
                                pMap[iRow + dir.0][iCol + dir.1] = portalId
                                portalMap[portalId] = [(iRow + dir.0, iCol + dir.1)]
                                portalId += 1
                            }
                            
                            pMap[iRow][iCol] = 0
                            pMap[iRow - dir.0][iCol - dir.1] = 0
                            break
                        }
                    }
                }
            }
        }
        
        let start = nameMapping[Set<Character>(["A"])]!
        let finish = nameMapping[Set<Character>(["Z"])]!
        
        var next = Deque<(Int, Int, Int)>()
        var vis = Set<Pos>()
        
        let startLoc = portalMap[start]![0]
        next.enqueue((startLoc.0, startLoc.1, 0))
        vis.insert(Pos(row: startLoc.0, col: startLoc.1))
        
        var shortestPath = 100000
        
        while !next.isEmpty {
            let state = next.dequeue()!
            var finished = false
            
            for dir in dirs {
                var nextPos = (state.0 + dir.0, state.1 + dir.1)
                let val = pMap[nextPos.0][nextPos.1]
                var addedSteps = 0
                
                if val == 0 {
                    continue
                }
                
                if vis.contains(Pos(row: nextPos.0, col: nextPos.1))
                    || pMap[nextPos.0][nextPos.1] == 0{
                    continue
                }
                
                if val > 1 {
                    if val == finish {
                        shortestPath = state.2 + 1
                        finished = true
                        break
                    } else if val != start {
                        nextPos = dest(entry: nextPos, entryPortal: val, portalMap: portalMap)
                        addedSteps += 1
                    }
                }
                
                next.enqueue((nextPos.0, nextPos.1, state.2 + 1 + addedSteps))
                vis.insert(Pos(row: nextPos.0, col: nextPos.1))
            }
            
            if finished {
                break
            }
        }
        
        return String(shortestPath)
    }
    
    static func part2(_ input: String) -> String {
        var map = input.trimmingCharacters(in: .newlines)
        .components(separatedBy: .newlines)
        .map { Array($0) }
                
        let width = map.map { $0.count }.max()!
        
        map = [Array(repeating: Character(" "), count: width)]
            + map
            + [Array(repeating: Character(" "), count: width)]
        
        for i in 0..<map.count {
            map[i] = [" "] + map[i] + Array(repeating: " ", count: width - map[i].count) + [" "]
        }
        
        var pMap = Array(repeating: Array(repeating: 0, count: map[0].count), count: map.count)
        var portalId = 2
        var portalMap = [Int: [(Int, Int)]]()
        var nameMapping = [Set<Character>: Int]()
        var bl = Set<Int>()
        for iRow in 1..<map.count-1 {
            for iCol in 1..<map[0].count-1 {
                if bl.contains(iRow * 1000 + iCol) {
                    continue
                }
                
                let val = map[iRow][iCol]
                if val == "." {
                    pMap[iRow][iCol] = 1
                } else if val.isLetter {
                    
                    for dir in dirs {
                        if map[iRow + dir.0][iCol + dir.1] == ".",
                        map[iRow - dir.0][iCol - dir.1].isLetter {
                            let letterSet = Set<Character>([val, map[iRow - dir.0][iCol - dir.1]])
                            
                            if !bl.contains((iRow - dir.0) * 1000 + (iCol - dir.1)) {
                                bl.insert((iRow - dir.0) * 1000 + (iCol - dir.1))
                                bl.insert((iRow + dir.0) * 1000 + (iCol + dir.1))
                            }
                            
                            if let id = nameMapping[letterSet] {
                                pMap[iRow + dir.0][iCol + dir.1] = id
                                portalMap[id]!.append((iRow + dir.0, iCol + dir.1))
                            } else {
                                nameMapping[letterSet] = portalId
                                pMap[iRow + dir.0][iCol + dir.1] = portalId
                                portalMap[portalId] = [(iRow + dir.0, iCol + dir.1)]
                                portalId += 1
                            }
                            
                            pMap[iRow][iCol] = 0
                            pMap[iRow - dir.0][iCol - dir.1] = 0
                            break
                        }
                    }
                }
            }
        }
        
        let start = nameMapping[Set<Character>(["A"])]!
        let finish = nameMapping[Set<Character>(["Z"])]!
        
        var next = Deque<(Pos2, Int)>()
        var vis = Set<Pos2>()
        
        let startLoc = portalMap[start]![0]
        next.enqueue((Pos2(row: startLoc.0, col: startLoc.1, level: 0), 0))
        vis.insert(Pos2(row: startLoc.0, col: startLoc.1, level: 0))
        
        var shortestPath = 100000
                
        while !next.isEmpty {
            let state = next.dequeue()!
            var finished = false
            
            for dir in dirs {
                var nextPos = (state.0.row + dir.0, state.0.col + dir.1)
                var nextLevel = state.0.level
                let val = pMap[nextPos.0][nextPos.1]
                var addedSteps = 0
                
                if val == 0 {
                    continue
                }
                
                if vis.contains(Pos2(row: nextPos.0, col: nextPos.1, level: state.0.level)){
                    continue
                }
                
                vis.insert(Pos2(row: nextPos.0, col: nextPos.1, level: state.0.level))
                
                if val > 1 {
                    if val == finish {
                        if state.0.level == 0 {
                            shortestPath = state.1 + 1
                            finished = true
                            break
                        } else {
                            continue
                        }
                    } else if val != start {
                        if !isInner(map: pMap, pos: nextPos), state.0.level == 0 {
                            continue
                        }
                        nextLevel = isInner(map: pMap, pos: nextPos) ? nextLevel + 1 : nextLevel - 1
                        nextPos = dest(entry: nextPos, entryPortal: val, portalMap: portalMap)
                        
                        vis.insert(Pos2(row: nextPos.0, col: nextPos.1, level: nextLevel))
                        
                        addedSteps += 1
                    }
                }

                next.enqueue((Pos2(row: nextPos.0, col: nextPos.1, level: nextLevel), state.1 + 1 + addedSteps))
            }
            
            if finished {
                break
            }
        }
        
        return String(shortestPath)
    }
    
    static func isInner(map: [[Int]], pos: (Int, Int)) -> Bool {
        
        var retVal = false
        if pos.0 == 3 || pos.0 == map.count - 4 || pos.1 == 3 || pos.1 == map[0].count - 4 {
            retVal = false
        } else {
            retVal = true
        }

        return retVal
        
    }
    
    static func dest(entry: (Int, Int), entryPortal: Int, portalMap: [Int: [(Int, Int)]]) -> (Int, Int) {
        let locs = portalMap[entryPortal]!
        
        return entry == locs[0] ? locs[1] : locs[0]
    }
}
