//
//  Day16.swift
//  AdventOfCode2019
//
//  Created by Lukas Capkovic on 14/12/2019.
//  Copyright © 2019 Lukas Capkovic. All rights reserved.
//

import Foundation

class Day16: Day {
    static func part1(_ input: String) -> String {
        var current = Array(input.trimmingCharacters(in: .newlines)).compactMap { $0.wholeNumberValue }
        var next = Array(repeating: 0, count: current.count)
        
        let base = [0, 1, 0, -1]
        
        for _ in 0..<100 {
            for element in 0..<current.count {
                let repCount = element + 1

                var elVal = (0..<current.count).reduce(0) { sum, i in
                    let ix = ((i+1) / repCount) % base.count
                    let mult = base[ix]

                    return sum + current[i] * mult
                }
                elVal = abs(elVal % 10)
                next[element] = elVal
            }

            current = next
        }
                
        return current[0..<8].reduce("") { return $0 + String($1) }
    }
    
    static func part2(_ input: String) -> String {
        let inp = Array(input.trimmingCharacters(in: .newlines)).compactMap { $0.wholeNumberValue }
        var current = (0..<10000).reduce(into: [Int]()) { arr, _ in arr += inp }
        
        let offset = Int(current[0..<7].reduce("") { $0 + String($1)})!
        
        current = Array(current[offset..<current.count])
        var next = Array(repeating: 0, count: current.count)

        for _ in 0..<100 {
            var cumSum = 0
            for element in (0..<current.count).reversed() {
                cumSum = (cumSum + current[element]) % 10
                next[element] = cumSum
            }
            current = next
        }

        return current[0..<8].reduce("") { return $0 + String($1) }
    }
}
