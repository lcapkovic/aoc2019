//
//  Day17.swift
//  AdventOfCode2019
//
//  Created by Lukas Capkovic on 16/12/2019.
//  Copyright © 2019 Lukas Capkovic. All rights reserved.
//

import Foundation

class Day17: Day {
    static let codes = [94: (-1,0), 62: (0,1), 60: (0,-1), 118: (1,0)]
    static func part1(_ input: String) -> String {
        let program = input.trimmingCharacters(in: .newlines)
        .components(separatedBy: CharacterSet(charactersIn: ","))
        .compactMap { Int($0) }
        
        let comp = IntcodeComp(code: program)
        comp.memory += Array(repeating: 0, count: 10000)
        
        comp.runUntilBlocked()
        var current = [Int]()
        var map = [[Int]]()
        
        for x in comp.output {
            if x == 10 {
                if current.count > 0 {
                    map.append(current)
                }
                
                current = []
            } else {
                current.append(x)
            }
        }
        
        var sum = 0
        
        for row in 1..<map.count-1 {
            for col in 1..<map[row].count-1 {
                if map[row-1][col] == 35,
                    map[row][col+1] == 35,
                    map[row+1][col] == 35,
                    map[row][col-1] == 35 {
                    sum += row * col
                }
            }
        }
        
        for row in map {
            for col in row {
                if col == 46 {
                    print(".", terminator: "")
                } else if col == 35 {
                    print("#", terminator: "")
                } else {
                    print("O", terminator: "")
                }
            }
            print()
        }
        
        return String(sum)
    }
    
    static func part2(_ input: String) -> String {
        var program = input.trimmingCharacters(in: .newlines)
        .components(separatedBy: CharacterSet(charactersIn: ","))
        .compactMap { Int($0) }
        
        program[0] = 2
        
        let comp = IntcodeComp(code: program)
        comp.memory += Array(repeating: 0, count: 10000)
        
        let routeASCII = Array("A,B,B,A,B,C,A,C,B,C\n").map { Int($0.asciiValue!) }
        let a = Array("L,4,L,6,L,8,L,12\n").map { Int($0.asciiValue!) }
        let b = Array("L,8,R,12,L,12\n").map { Int($0.asciiValue!) }
        let c = Array("R,12,L,6,L,6,L,8\n").map { Int($0.asciiValue!) }
        let last = Array("n\n").map { Int($0.asciiValue!) }
        
        comp.input = routeASCII + a + b + c + last
        comp.runUntilBlocked()

        return String(comp.output.last!)
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

