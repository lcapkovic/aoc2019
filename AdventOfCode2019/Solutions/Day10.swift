//
//  Day10.swift
//  AdventOfCode2019
//
//  Created by Lukas Capkovic on 09/12/2019.
//  Copyright © 2019 Lukas Capkovic. All rights reserved.
//

import Foundation

class Day10: Day {
    
    static func part1(_ input: String) -> String {
        let map = input.trimmingCharacters(in: .newlines)
            .components(separatedBy: .newlines)
            .map { $0.map { $0 == "." ? 0 : 1 } }
        
        var maxCount = 0
        var maxAst = (0,0)

        for row in 0..<map.count {
            for col in 0..<map[row].count {
                if map[row][col] == 1 {
                    let count = countAsts(from: (row, col), map: map)

                    if count > maxCount {
                        maxCount = count
                        maxAst = (row, col)
                    }
                }

            }
        }
        
        print(maxAst)
        return String(maxCount)
    }
    
    static func countAsts(from: (Int, Int), map: [[Int]]) -> Int {
        var slopeSet1 = Set<Double>()
        
        for row in 0..<from.0 {
            for col in 0..<map[0].count {
                if map[row][col] == 1, (row,col) != from {
                    let vec = (row - from.0, col - from.1)
                    let slope = Double(vec.1) / Double(vec.0)
                    slopeSet1.insert(slope)
                }
            }
        }
        
        var slopeSet2 = Set<Double>()
        
        for row in from.0..<map.count {
            for col in 0..<map[0].count {
                if map[row][col] == 1, (row,col) != from {
                    let vec = (row - from.0, col - from.1)
                    let slope = Double(vec.1) / Double(vec.0)
                    slopeSet2.insert(slope)
                }
            }
        }
        return slopeSet1.count + slopeSet2.count
    }
    
    static func raycast(from: (Int, Int), vec: (Int, Int), map: [[Int]]) -> (Int, Int) {
        var cur = (from.0 + vec.0, from.1 + vec.1)
        
        while cur.0 >= 0,
            cur.1 >= 0,
            cur.0 < map.count,
            cur.1 < map[cur.0].count {
                if map[cur.0][cur.1] == 1 {
                    return cur
                }
                
                cur = (cur.0 + vec.0, cur.1 + vec.1)
        }
        
        return from
    }
    
    static func part2(_ input: String) -> String {
        var map = input.trimmingCharacters(in: .newlines)
            .components(separatedBy: .newlines)
            .map { $0.map { $0 == "." ? 0 : 1 } }
        
        var counter = 0
        var res = (0,0)
        
        while counter < 200 {
            let start = (25,22)
            
            var asts = [(Int,Int)]()
            
            let above = raycast(from: start, vec: (-1,0), map: map)
            let below = raycast(from: start, vec: (1,0), map: map)
            
            if above != start {
                asts.append(above)
            }
            
            if below != start {
                asts.append(below)
            }
            
            for col in start.1+1..<map[0].count {
                for row in 0..<map.count {
                    let vec = (row - start.0, col - start.1)
                    
                    if !asts.contains(where: { ast in
                        let vec2 = (ast.0 - start.0, ast.1 - start.1)
                        
                        return Double(vec2.1)/Double(vec2.0) == Double(vec.1)/Double(vec.0)
                    }) {
                        let hit = raycast(from: start, vec: vec, map: map)
                        if hit != start {
                            asts.append(hit)
                        }
                    }
                }
            }
            
            asts.sort(by: {
                let vec1 = ($0.0 - start.0, $0.1 - start.1)
                let vec2 = ($1.0 - start.0, $1.1 - start.1)
                
                return Double(vec1.0) / Double(vec1.1) < Double(vec2.0) / Double(vec2.1)
            })
            
            let rightSemi = asts
            
            asts = [(Int,Int)]()
            
            for col in (0..<start.1).reversed() {
                for row in 0..<map.count {
                    let vec = (row - start.0, col - start.1)
                    
                    if !asts.contains(where: { ast in
                        let vec2 = (ast.0 - start.0, ast.1 - start.1)
                        
                        return Double(vec2.1)/Double(vec2.0) == Double(vec.1)/Double(vec.0)
                    }) {
                        let hit = raycast(from: start, vec: vec, map: map)
                        if hit != start {
                            asts.append(hit)
                        }
                    }
                }
            }
            
            asts.sort(by: {
                let vec1 = ($0.0 - start.0, $0.1 - start.1)
                let vec2 = ($1.0 - start.0, $1.1 - start.1)
                
                return Double(vec1.0) / Double(vec1.1) < Double(vec2.0) / Double(vec2.1)
            })
            
            asts = rightSemi + asts
            
            for ast in asts {
                map[ast.0][ast.1] = 0
                counter += 1
                
                if counter == 200 {
                    res = ast
                    break
                }
            }
            
            
        }

                
        return "\(res)"
    }
}
