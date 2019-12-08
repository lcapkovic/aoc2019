//
//  Day4.swift
//  AdventOfCode2019
//
//  Created by Lukas Capkovic on 03/12/2019.
//  Copyright © 2019 Lukas Capkovic. All rights reserved.
//

import Foundation

class Day4: Day {
    static func part1(_ input: String) -> String {
        let range = input.trimmingCharacters(in: .newlines)
            .components(separatedBy: CharacterSet(charactersIn: "-"))
            .compactMap { Int($0) }
        
        var counter = 0
        
        for i in range[0]..<range[1] {
            let digits = String(i).compactMap { $0.wholeNumberValue }
            
            var prevDigit = digits[0]
            var hasDouble = false
            var isIncreasing = true
            
            for d in digits.dropFirst() {
                if d == prevDigit {
                    hasDouble = true
                }
                
                if d < prevDigit {
                    isIncreasing = false
                    break
                }
                
                prevDigit = d
            }
            
            if hasDouble && isIncreasing {
                counter += 1
            }
        }
        
        return String(counter)
    }
    
    static func part2(_ input: String) -> String {
        let range = input.trimmingCharacters(in: .newlines)
            .components(separatedBy: CharacterSet(charactersIn: "-"))
            .compactMap { Int($0) }
        
        var counter = 0
        
        for i in range[0]..<range[1] {
            let digits = String(i).compactMap { $0.wholeNumberValue }
            
            var prevDigit = digits[0]
            
            var repCount = 0
            var hasDouble = false
            var isIncreasing = true
            
            for d in digits.dropFirst() {
                if d == prevDigit {
                    repCount += 1
                } else {
                    if repCount == 1 {
                        hasDouble = true
                    }
                    
                    repCount = 0
                }
                
                if d < prevDigit {
                    isIncreasing = false
                    break
                }
                
                prevDigit = d
            }
            
            if repCount == 1 {
                hasDouble = true
            }
            
            if hasDouble && isIncreasing {
                counter += 1
            }
        }
        
        return String(counter)
    }
}
