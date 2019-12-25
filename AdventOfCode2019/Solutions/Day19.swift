//
//  Day19.swift
//  AdventOfCode2019
//
//  Created by Lukas Capkovic on 21/12/2019.
//  Copyright © 2019 Lukas Capkovic. All rights reserved.
//

import Foundation

class Day19: Day {
    static func part1(_ input: String) -> String {
        let program = input.trimmingCharacters(in: .newlines)
        .components(separatedBy: CharacterSet(charactersIn: ","))
        .compactMap { Int($0) }
        
        let comp = IntcodeComp(code: program + Array(repeating: 0, count: 10000))
        
        var count = 0
        
        for x in 0..<50 {
            for y in 0..<50 {
                comp.input.enqueue(x)
                comp.input.enqueue(y)
                comp.runUntilBlocked()
                count += comp.output.last!
//                print(comp.output.last!, terminator: "")
                comp.output.removeAll()
                comp.reset()
            }
//            print()
        }
        
        return String(count)
    }
    
    static func part2(_ input: String) -> String {
        let program = input.trimmingCharacters(in: .newlines)
        .components(separatedBy: CharacterSet(charactersIn: ","))
        .compactMap { Int($0) }
        
        let comp = IntcodeComp(code: program + Array(repeating: 0, count: 10000))
            
        var lb = 1000
        var ub = 2000
        var y = 1
        var last = 2

        while last != y {
            last = y
            y = lb + ((ub - lb) / 2)

            if fits(comp: comp, y: y) {
                ub = y
            } else {
                lb = y
            }
        }
        
        return String(topLeft(comp: comp, y: y+1))
    }
    
    static fileprivate func topLeft(comp: IntcodeComp, y: Int) -> Int {
        comp.reset()
        var entered = false
        var x = 950
        
        while true {
            comp.input.enqueue(x)
            comp.input.enqueue(y)
            comp.runUntilBlocked()
            let val = comp.output.last!
            
            comp.output.removeAll()
            comp.reset()
            
            if !entered && val == 1 {
                entered = true
            }
            
            if entered && val == 0 {
                break
            }
            
            x += 1
        }
        
        let xAns = x - 100
        
        return xAns * 10000 + y
    }
    
    static fileprivate func fits(comp: IntcodeComp, y: Int) -> Bool {
        comp.reset()
        var entered = false
        var x = 950
        
        while true {
            comp.input.enqueue(x)
            comp.input.enqueue(y)
            comp.runUntilBlocked()
            let val = comp.output.last!
            
            comp.output.removeAll()
            comp.reset()
            
            if !entered && val == 1 {
                entered = true
            }
            
            if entered && val == 0 {
                break
            }
            
            x += 1
        }
        
        comp.input.enqueue(x-100)
        comp.input.enqueue(y+99)
        comp.runUntilBlocked()
        
        return comp.output.last! == 1
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
