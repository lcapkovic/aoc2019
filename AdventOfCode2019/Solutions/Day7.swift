//
//  Day7.swift
//  AdventOfCode2019
//
//  Created by Lukas Capkovic on 08/12/2019.
//  Copyright © 2019 Lukas Capkovic. All rights reserved.
//

import Foundation

class Day7: Day {
    static func part1(_ input: String) -> String {
        let codeOrig = input.trimmingCharacters(in: .newlines)
            .components(separatedBy: CharacterSet(charactersIn: ","))
            .compactMap { Int($0) }
        
        return String(bestPerm(phases: [], code: codeOrig))
    }
    
    static func part2(_ input: String) -> String {
        let codeOrig = input.trimmingCharacters(in: .newlines)
            .components(separatedBy: CharacterSet(charactersIn: ","))
            .compactMap { Int($0) }
        
        return String(bestPerm2(phases: [], code: codeOrig))
    }
    
    static func bestPerm(phases: [Int], code: [Int]) -> Int {
        if phases.count == 5 {
            return testPhases(phases: phases, code: code)
        }
        
        var best = 0
        for n in 0..<5 {
            if phases.contains(n) {
                continue
            }
            
            best = max(best, bestPerm(phases: phases + [n], code: code))
        }
        
        return best
    }
    
    static func bestPerm2(phases: [Int], code: [Int]) -> Int {
        if phases.count == 5 {
            return testPhases2(phases: phases, code: code)
        }
        
        var best = 0
        for n in 5...9 {
            if phases.contains(n) {
                continue
            }
            
            best = max(best, bestPerm2(phases: phases + [n], code: code))
        }
        
        return best
    }
    
    static func testPhases(phases: [Int], code: [Int]) -> Int {
        let comps = phases.map { _ in IntcodeComp(code: code) }

        var prevOutput = 0
        for i in 0..<comps.count {
           let input = [phases[i], prevOutput]
           comps[i].input = input
           comps[i].runUntilBlocked()
           prevOutput = comps[i].output[0]
        }

        return prevOutput
    }
    
    static func testPhases2(phases: [Int], code: [Int]) -> Int {
        let comps = phases.map { _ in IntcodeComp(code: code) }
    
        comps[0].output = [phases[1]]
        comps[1].output = [phases[2]]
        comps[2].output = [phases[3]]
        comps[3].output = [phases[4]]
        comps[4].output = [phases[0], 0]
        
        while !comps[4].halted {
            for i in 0..<comps.count {
                let prevComp = i == 0 ? 4 : i-1
                
                while comps[prevComp].output.count > 0 {
                    comps[i].input = [comps[prevComp].output.first!]
                    
                    comps[prevComp].output = Array(comps[prevComp].output.dropFirst())
                    comps[i].runUntilBlocked()
                }
            }
        }

        return comps[4].output[0]
    }
}

class IntcodeComp {
    var memory: [Int]
    
    let code: [Int]
    
    var input = [Int]()
    
    var output = [Int]()
    
    var ip = 0
    
    var halted = false
    
    init(code: [Int]) {
        self.memory = code
        self.code = code
    }
    
    func runUntilBlocked() {
        while ip < memory.count {
            var oComps = Array(String(memory[ip]).compactMap { $0.wholeNumberValue }.reversed())
            oComps = oComps + Array(repeating: 0, count: 4 - oComps.count)

            let (opcode, mod1, mod2) = (oComps[0] + 10 * oComps[1], oComps[2], oComps[3])
            
            if opcode == 99 {
                break
            } else if opcode == 3 {
                if input.count == 0 {
                    return
                }
                
                memory[memory[ip+1]] = input.first!
                input = Array(input.dropFirst())
                ip += 2
            } else if opcode == 4 {
                output.append(mod1 == 1 ? memory[ip+1] : memory[memory[ip+1]])
                ip += 2
            } else {
                let par1 = mod1 == 1 ? memory[ip+1] : memory[memory[ip+1]]
                let par2 = mod2 == 1 ? memory[ip+2] : memory[memory[ip+2]]
                
                switch opcode {
                case 1:
                    memory[memory[ip+3]] = par1 + par2
                    ip += 4
                case 2:
                    memory[memory[ip+3]] = par1 * par2
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
                    memory[memory[ip+3]] = par1 < par2 ? 1 : 0
                    ip += 4
                case 8:
                    memory[memory[ip+3]] = par1 == par2 ? 1 : 0
                    ip += 4
                default:
                    ()
                }
            }
        }
        halted = true
    }
}
