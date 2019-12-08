//
//  Day5.swift
//  AdventOfCode2019
//
//  Created by Lukas Capkovic on 05/12/2019.
//  Copyright © 2019 Lukas Capkovic. All rights reserved.
//

import Foundation

class Day5: Day {
    static func part1(_ input: String) -> String {
        var ints = input.trimmingCharacters(in: .newlines)
            .components(separatedBy: CharacterSet(charactersIn: ","))
            .compactMap { Int($0) }
        
        var ip = 0
        var lastOutput = 0
                
        while ip < ints.count {
            var oComps = Array(String(ints[ip]).compactMap { $0.wholeNumberValue }.reversed())
            oComps = oComps + Array(repeating: 0, count: 5 - oComps.count)

            let (opcode, mod1, mod2, _) = (oComps[0] + 10 * oComps[1], oComps[2], oComps[3], oComps[4])
            
            if opcode == 99 {
                break
            } else if opcode == 3 {
                ints[ints[ip+1]] = 1
                ip += 2
            } else if opcode == 4 {
                lastOutput = mod1 == 1 ? ints[ip+1] : ints[ints[ip+1]]
                print(lastOutput)
                ip += 2
            } else {
                let par1 = mod1 == 1 ? ints[ip+1] : ints[ints[ip+1]]
                let par2 = mod2 == 1 ? ints[ip+2] : ints[ints[ip+2]]
                
                switch opcode {
                case 1:
                    ints[ints[ip+3]] = par1 + par2
                case 2:
                    ints[ints[ip+3]] = par1 * par2
                default:
                    ()
                }
                
                ip += 4
            }
        }
        
        return String(lastOutput)
    }
    
    static func part2(_ input: String) -> String {
        var ints = input.trimmingCharacters(in: .newlines)
            .components(separatedBy: CharacterSet(charactersIn: ","))
            .compactMap { Int($0) }
        
        var ip = 0
        var lastOutput = 0
                
        while ip < ints.count {
            var oComps = Array(String(ints[ip]).compactMap { $0.wholeNumberValue }.reversed())
            oComps = oComps + Array(repeating: 0, count: 4 - oComps.count)

            let (opcode, mod1, mod2) = (oComps[0] + 10 * oComps[1], oComps[2], oComps[3])
            
            if opcode == 99 {
                break
            } else if opcode == 3 {
                ints[ints[ip+1]] = 5
                ip += 2
            } else if opcode == 4 {
                lastOutput = mod1 == 1 ? ints[ip+1] : ints[ints[ip+1]]
                print(lastOutput)
                ip += 2
            } else {
                let par1 = mod1 == 1 ? ints[ip+1] : ints[ints[ip+1]]
                let par2 = mod2 == 1 ? ints[ip+2] : ints[ints[ip+2]]
                
                switch opcode {
                case 1:
                    ints[ints[ip+3]] = par1 + par2
                    ip += 4
                case 2:
                    ints[ints[ip+3]] = par1 * par2
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
                    ints[ints[ip+3]] = par1 < par2 ? 1 : 0
                    ip += 4
                case 8:
                    ints[ints[ip+3]] = par1 == par2 ? 1 : 0
                    ip += 4
                default:
                    ()
                }
            }
        }
        
        return String(lastOutput)
    }
    
    
}
