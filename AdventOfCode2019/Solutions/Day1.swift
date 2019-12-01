//
//  Day1.swift
//  AdventOfCode2019
//
//  Created by Lukas Capkovic on 30/11/2019.
//  Copyright © 2019 Lukas Capkovic. All rights reserved.
//

import Foundation

class Day1: Day {
    static func part1(_ input: String) -> String {
        let ans: Double = input.trimmingCharacters(in: .newlines).components(separatedBy: .newlines)
            .compactMap { Double($0) }
            .map { floor($0 / 3) - 2 }
            .reduce(0, +)
        
        return String(Int(ans))
    }
    
    static func part2(_ input: String) -> String {
        let modules = input.trimmingCharacters(in: .newlines).components(separatedBy: .newlines).compactMap { Double($0) }
        
        var ans: Double = 0
        
        for module in modules {
            var curMass = module
            
            repeat {
                curMass = max(0, floor(curMass / 3) - 2)
                ans += curMass
            } while curMass > 0
        }
        
        return String(Int(ans))
    }
}
