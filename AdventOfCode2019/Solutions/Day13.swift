//
//  Day13.swift
//  AdventOfCode2019
//
//  Created by Lukas Capkovic on 12/12/2019.
//  Copyright © 2019 Lukas Capkovic. All rights reserved.
//

import Foundation

class Day13: Day {
    static func part1(_ input: String) -> String {
        let program = input.trimmingCharacters(in: .newlines)
            .components(separatedBy: CharacterSet(charactersIn: ","))
            .compactMap { Int($0) }
        
        let comp = IntcodeComp(code: program)
        comp.memory += Array(repeating: 0, count: 10000)
        
        comp.runUntilBlocked()
                
        var map = Array(repeating: Array(repeating: 0, count: 50), count: 50)
                    
        for i in 0..<comp.output.count/3 {
            let ix = 3*i
            
            map[comp.output[ix]][comp.output[ix+1]] = comp.output[ix+2]
        }
        
        return String(map.flatMap { $0 }.reduce(0) { $0 + ($1 == 2 ? 1 : 0) })
        
    }
    
    static func part2(_ input: String) -> String {
        let program = input.trimmingCharacters(in: .newlines)
            .components(separatedBy: CharacterSet(charactersIn: ","))
            .compactMap { Int($0) }
        
        let comp = IntcodeComp(code: program)
        comp.memory += Array(repeating: 0, count: 10000)
        comp.memory[0] = 2
                
        var map = Array(repeating: Array(repeating: 0, count: 50), count: 25)
        var blockCount = 1
        var score = 0
        
        while blockCount > 0 {
            comp.runUntilBlocked()
            
            for i in 0..<comp.output.count/3 {
                let ix = 3*i
                
                if comp.output[ix] != -1 || comp.output[ix+1] != 0 {
                    map[comp.output[ix+1]][comp.output[ix]] = comp.output[ix+2]
                } else {
                    score = comp.output[ix+2]
                }
            }
            
//            drawMap(map: map)
            blockCount = map.flatMap { $0 }.reduce(0) { $0 + ($1 == 2 ? 1 : 0) }
            
            comp.output = []
            comp.input = [0]
        }
        return String(score)
    }
    
    static func drawMap(map: [[Int]]) {
        for row in map {
            for px in row {
                var toPrint = ""
                switch px {
                case 0:
                    toPrint = " "
                case 1:
                    toPrint = "▓"
                case 2:
                    toPrint = "░"
                case 3:
                    toPrint = "_"
                default:
                    toPrint = "o"
                }
                print(toPrint, terminator: "")
            }
            print()
        }
    }
    
    struct SimpleTile: Hashable {
        var x: Int
        var y: Int
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
