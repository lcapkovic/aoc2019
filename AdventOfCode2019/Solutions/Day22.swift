//
//  Day22.swift
//  AdventOfCode2019
//
//  Created by Lukas Capkovic on 22/12/2019.
//  Copyright © 2019 Lukas Capkovic. All rights reserved.
//

import Foundation

class Day22: Day {
    static func part1(_ input: String) -> String {
        let lines = input.trimmingCharacters(in: .newlines)
            .components(separatedBy: .newlines)
        
        var cards = Array(0..<10007)
                                
        for line in lines {
            let tokens = line.components(separatedBy: .whitespaces)
            if tokens[0] == "cut" {
                cut(n: Int(tokens[1])!, cards: &cards)
            } else if tokens[1] == "into" {
                cards = cards.reversed()
            } else {
                dInc(inc: Int(tokens[3])!, cards: &cards)
            }
        }
        
        return String(cards.firstIndex(of: 2019)!)
    }
    
    static func cut(n: Int, cards: inout [Int]) {
        let N = n < 0 ? cards.count - abs(n) : n
        
        cards = Array(cards[N..<cards.count]) + Array(cards[0..<N])
    }
    
    static func dInc(inc: Int, cards: inout [Int]) {
        let s = Array(stride(from: 0, to: cards.count*inc, by: inc))
        let cardsCopy = cards
        
        for i in 0..<cards.count {
            cards[s[i] % cards.count] = cardsCopy[i]
        }
    }
    
    static func part2(_ input: String) -> String {
        return ""
    }
    
    
}
