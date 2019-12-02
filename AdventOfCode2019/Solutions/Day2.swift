//
//  Day2.swift
//  AdventOfCode2019
//
//  Created by Lukas Capkovic on 01/12/2019.
//  Copyright © 2019 Lukas Capkovic. All rights reserved.
//

import Foundation

class Day2: Day {
    static func part1(_ input: String) -> String {
        var data = input.trimmingCharacters(in: .newlines)
            .components(separatedBy: .punctuationCharacters).compactMap { Int($0) }
        
        data[1] = 12
        data[2] = 2
        
        return String(simulate(startState: data))
    }
    
    static func part2(_ input: String) -> String {
        let backup = input.trimmingCharacters(in: .newlines)
            .components(separatedBy: .punctuationCharacters).compactMap { Int($0) }
        
        for noun in 0...99 {
            for verb in 0...99 {
                var data = backup
                data[1] = noun
                data[2] = verb
                
                let output = simulate(startState: data)
               
                if output == 19690720 {
                    return String(100 * noun + verb)
                }
            }
        }
        
       return ""
    }
    
    static func simulate(startState: [Int]) -> Int {
        var ip = 0
        
        var data = startState
        
        while ip < data.count {
            switch data[ip] {
            case 99:
                break
            case 1:
                data[data[ip+3]] = data[data[ip+1]] + data[data[ip+2]]
            case 2:
                data[data[ip+3]] = data[data[ip+1]] * data[data[ip+2]]
            default:
                ()
            }

            ip += 4
        }
        
        return data[0]
    }
}
