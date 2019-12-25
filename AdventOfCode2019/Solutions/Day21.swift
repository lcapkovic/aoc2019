//
//  Day21.swift
//  AdventOfCode2019
//
//  Created by Lukas Capkovic on 21/12/2019.
//  Copyright © 2019 Lukas Capkovic. All rights reserved.
//

import Foundation

class Day21: Day {
    static func part1(_ input: String) -> String {
        let program = input.trimmingCharacters(in: .newlines)
        .components(separatedBy: CharacterSet(charactersIn: ","))
        .compactMap { Int($0) }
        
        let comp = IntcodeComp(code: program + Array(repeating: 0, count: 10000))
        let pr = """
            NOT A T
            NOT B J
            OR T J
            NOT C T
            OR T J
            AND D J
            WALK\n
        """
        (pr.compactMap { $0.asciiValue }).forEach({ comp.input.enqueue(Int($0)) })
        comp.runUntilBlocked()
                
        if comp.output.last! > 100 {
            return String(comp.output.last!)
        }
        
        let out = comp.output.map { Character(UnicodeScalar($0)!) }.reduce("", { $0 + String($1)})
        print(out)
        
        return ""
    }
    
    static func part2(_ input: String) -> String {
        let program = input.trimmingCharacters(in: .newlines)
        .components(separatedBy: CharacterSet(charactersIn: ","))
        .compactMap { Int($0) }
        
        let comp = IntcodeComp(code: program + Array(repeating: 0, count: 10000))
        let pr = """
            NOT A T
            NOT B J
            OR T J
            NOT C T
            OR T J
            AND D J
            NOT E T
            NOT T T
            OR H T
            AND T J
            RUN\n
        """
        (pr.compactMap { $0.asciiValue }).forEach({ comp.input.enqueue(Int($0)) })
        comp.runUntilBlocked()
                
        if comp.output.last! > 100 {
            return String(comp.output.last!)
        }
        
        let out = comp.output.map { Character(UnicodeScalar($0)!) }.reduce("", { $0 + String($1)})
        print(out)
        
        return ""
    }
    
    
}

fileprivate class IntcodeComp {
    var memory: [Int]
    
    let code: [Int]
    
    var input = Deque<Int>()
    
    var output = [Int]()
    
    var relBase = 0
    
    var ip = 0
    
    var halted = false
    
    init(code: [Int]) {
        self.memory = code
        self.code = code
    }
    
    func reset() {
        ip = 0
        relBase = 0
        halted = false
        memory = code
    }
    
    func runUntilBlocked() {
        while ip < memory.count {
            var oComps = Array(String(memory[ip]).compactMap { $0.wholeNumberValue }.reversed())
            oComps = oComps + Array(repeating: 0, count: 5 - oComps.count)

            let (opcode, mod1, mod2, mod3) = (oComps[0] + 10 * oComps[1], oComps[2], oComps[3], oComps[4])
            
            if opcode == 99 {
                break
            } else if opcode == 3 {
                if input.isEmpty {
                    return
                }
                
                // Check for rel mode
                if mod1 == 2 {
                    memory[relBase + memory[ip+1]] = input.dequeue()!
                } else {
                    memory[memory[ip+1]] = input.dequeue()!
                }
                                
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
