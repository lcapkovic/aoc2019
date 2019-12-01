//
//  Day.swift
//  AdventOfCode2016
//
//  Created by Lukas Capkovic on 27/11/2019.
//  Copyright © 2019 Lukas Capkovic. All rights reserved.
//

import Foundation

protocol Day {
    static func part1(_ input: String) -> String
    
    static func part2(_ input: String) -> String
}

extension Day {
    static func solve(with input: String) {
        guard let inputStr = try? Input.get(input) else {
            print("Could not load the file \(input)")
            return
        }
        
        print("Solving \(Self.self) on \(input)")
        let start = CFAbsoluteTimeGetCurrent()
        print("Part 1: \(part1(inputStr))")
        print("Part 2: \(part2(inputStr))")
        
        let end = CFAbsoluteTimeGetCurrent()
        let elapsed = (end - start) * 1000
        
        let formatted = String(format: "%.5f", elapsed)
        
        print("Execution time: \(formatted)ms.")
    }
}
