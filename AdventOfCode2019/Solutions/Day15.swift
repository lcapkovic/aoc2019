//
//  Day15.swift
//  AdventOfCode2019
//
//  Created by Lukas Capkovic on 14/12/2019.
//  Copyright © 2019 Lukas Capkovic. All rights reserved.
//

import Foundation

class Day15: Day {
    static let opps =  [1:2, 2:1, 3:4, 4:3]
    static let dirs = [1: (-1,0), 2: (1,0), 3: (0,-1), 4: (0,1)]
    
    static func part1(_ input: String) -> String {
        let program = input.trimmingCharacters(in: .newlines)
        .components(separatedBy: CharacterSet(charactersIn: ","))
        .compactMap { Int($0) }
        
        let comp = IntcodeComp(code: program)
        comp.memory += Array(repeating: 0, count: 10000)
        
        var map = Array(repeating: Array(repeating: 3, count: 50), count: 50)
        let start = (25, 25)
        
        _ = fillMap(comp: comp, start: start, map: &map)
        
        return String(findOxygen(start: start, map: map, steps: 0, avoid: 0))
    }
    
    static func part2(_ input: String) -> String {
        let program = input.trimmingCharacters(in: .newlines)
        .components(separatedBy: CharacterSet(charactersIn: ","))
        .compactMap { Int($0) }
        
        let comp = IntcodeComp(code: program)
        comp.memory += Array(repeating: 0, count: 10000)
        
        var map = Array(repeating: Array(repeating: 3, count: 50), count: 50)
        let start = (25, 25)
        
        let oxLoc = fillMap(comp: comp, start: start, map: &map)
        distOxygen(pos: oxLoc, map: &map, depth: -1)
        
        return String(-map.map { $0.min()! }.min()! - 1)
    }
    
    fileprivate static func fillMap(comp: IntcodeComp, start: (Int, Int), map: inout [[Int]]) -> (Int, Int) {
        var pos = (start.0, start.1)
        map[pos.0][pos.1] = 1
        
        var route = [Int]()
        var oxLoc = (0,0)
        
        while true {
            if map[pos.0][pos.1] == 2 {
                oxLoc = pos
            }
            var moved = false
            
            for kv in dirs {
                let vec = kv.value
                
                if map[pos.0 + vec.0][pos.1 + vec.1] == 3 {
                    pos = (pos.0 + vec.0, pos.1 + vec.1)
                    
                    comp.input = [kv.key]
                    comp.runUntilBlocked()
                    
                    map[pos.0][pos.1] = comp.output[0]
                    
                    if map[pos.0][pos.1] == 0 {
                        pos = (pos.0 - vec.0, pos.1 - vec.1)
                    } else {
                        moved = true
                        route.append(kv.key)
                    }
                    comp.output = []
                    
                    if moved {
                        break
                    }
                }
            }
            
            if moved {
                continue
            }
            
            if !route.isEmpty {
                // Backtrack
                comp.input = [opps[route.last!]!]
                let vec = dirs[opps[route.last!]!]!
                pos = (pos.0 + vec.0, pos.1 + vec.1)
                route = route.dropLast()
                comp.runUntilBlocked()
                comp.output = []
            } else {
                break
            }
        }
        
        return oxLoc
    }
    
    static func findOxygen(start: (Int, Int), map: [[Int]], steps: Int, avoid: Int) -> Int {
        if map[start.0][start.1] == 2 {
            return steps
        }
        
        var minSteps = 100000
        for kv in dirs {
            if kv.key == avoid {
                continue
            }
            
            let newPos = (start.0 + kv.value.0, start.1 + kv.value.1)
            
            if map[newPos.0][newPos.1] == 0 {
                continue
            }
            
            minSteps = min(minSteps, findOxygen(start: newPos, map: map, steps: steps+1, avoid: opps[kv.key]!))
        }
        
        return minSteps
    }
    
    static func distOxygen(pos: (Int, Int), map: inout [[Int]], depth: Int) {
        let val = map[pos.0][pos.1]
        if val == 0 || (val < 0 && val > depth) {
            return
        }
        
        if val > 0 || val < depth {
            map[pos.0][pos.1] = depth
        }
        
        for kv in dirs {
            distOxygen(pos: (pos.0 + kv.value.0, pos.1 + kv.value.1), map: &map, depth: depth-1)
        }
    }
}

fileprivate class IntcodeComp {
    var memory: [Int]
    
    let code: [Int]
    
    var input = [Int]()
    
    var output = [Int]()
    
    var relBase = 0
    
    var ip = 0
    
    var halted = false
    
    init(code: [Int]) {
        self.memory = code
        self.code = code
    }
    
    func runUntilBlocked() {
        while ip < memory.count {
            var oComps = Array(String(memory[ip]).compactMap { $0.wholeNumberValue }.reversed())
            oComps = oComps + Array(repeating: 0, count: 5 - oComps.count)

            let (opcode, mod1, mod2, mod3) = (oComps[0] + 10 * oComps[1], oComps[2], oComps[3], oComps[4])
            
            if opcode == 99 {
                break
            } else if opcode == 3 {
                if input.count == 0 {
                    return
                }
                
                // Check for rel mode
                if mod1 == 2 {
                    memory[relBase + memory[ip+1]] = input.first!
                } else {
                    memory[memory[ip+1]] = input.first!
                }
                                
                input = Array(input.dropFirst())
                ip += 2
            } else if opcode == 4 {
                switch mod1 {
                case 0:
                    output.append(memory[memory[ip+1]])
                case 1:
                    output.append(memory[ip+1])
                case 2:
                    output.append(memory[relBase + memory[ip+1]])
                default:
                    ()
                }
                ip += 2
            } else if opcode == 9 {
                switch mod1 {
                case 0:
                    relBase += memory[memory[ip+1]]
                case 1:
                    relBase += memory[ip+1]
                default:
                    relBase += memory[relBase + memory[ip+1]]
                }
                ip += 2
            } else {
                let par1 = mod1 == 1 ? memory[ip+1] : (mod1 == 0 ? memory[memory[ip+1]] : memory[relBase + memory[ip+1]])
                let par2 = mod2 == 1 ? memory[ip+2] : (mod2 == 0 ? memory[memory[ip+2]] : memory[relBase + memory[ip+2]])
                
                switch opcode {
                case 1:
                    if mod3 == 0 {
                        memory[memory[ip+3]] = par1 + par2
                    } else {
                        memory[relBase + memory[ip+3]] = par1 + par2
                    }
                    
                    ip += 4
                case 2:
                    if mod3 == 0 {
                        memory[memory[ip+3]] = par1 * par2
                    } else {
                        memory[relBase + memory[ip+3]] = par1 * par2
                    }
                    ip += 4
                case 5:
                    if par1 != 0 {
                        ip = par2
                    } else {
                        ip += 3
                    }
                case 6:
                    if par1 == 0 {
                        ip = par2
                    } else {
                        ip += 3
                    }
                case 7:
                    if mod3 == 0 {
                        memory[memory[ip+3]] = par1 < par2 ? 1 : 0
                    } else {
                        memory[relBase + memory[ip+3]] = par1 < par2 ? 1 : 0
                    }
                    
                    ip += 4
                case 8:
                    if mod3 == 0 {
                        memory[memory[ip+3]] = par1 == par2 ? 1 : 0
                    } else {
                        memory[relBase + memory[ip+3]] = par1 == par2 ? 1 : 0
                    }
                    
                    ip += 4
                default:
                    ()
                }
            }
        }
        halted = true
    }
}
