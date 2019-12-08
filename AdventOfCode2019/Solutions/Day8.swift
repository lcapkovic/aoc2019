//
//  Day8.swift
//  AdventOfCode2019
//
//  Created by Lukas Capkovic on 08/12/2019.
//  Copyright © 2019 Lukas Capkovic. All rights reserved.
//

import Foundation

class Day8: Day {
    static let w = 25
    static let h = 6
    
    static func part1(_ input: String) -> String {
        let pass = Array(input.trimmingCharacters(in: .newlines))
            .compactMap { $0.wholeNumberValue }
        
        let layered = pass.chunked(into: w*h)
        let bestLayer = layered.reduce(into: [Int]()) { best, current in
            if best == [] || current.filter({ $0 == 0 }).count < best.filter({ $0 == 0 }).count {
                best = current
            }
        }
        
        return String(bestLayer.filter({$0 == 1}).count * bestLayer.filter({$0 == 2}).count)
    }
    
    static func part2(_ input: String) -> String {
        let pass = Array(input.trimmingCharacters(in: .newlines))
            .compactMap { $0.wholeNumberValue }
        
        let layered = pass.chunked(into: w*h)
        
        let squashed = layered.reduce(into: Array(repeating: 2, count: w*h)) { squashed, current in
            for i in 0..<squashed.count {
                if squashed[i] == 2 {
                    squashed[i] = current[i]
                }
            }
        }
        
        for row in 0..<h {
            for col in 0..<w {
                print(squashed[row*w + col] == 1 ? "O" : " ", terminator: "")
            }
            print()
        }
        
        return "^^^ Answer is above ^^^"
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
