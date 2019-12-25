//
//  Day14.swift
//  AdventOfCode2019
//
//  Created by Lukas Capkovic on 14/12/2019.
//  Copyright © 2019 Lukas Capkovic. All rights reserved.
//

import Foundation

class Day14: Day {
    static func part1(_ input: String) -> String {
        var leftovers = [String: Int]()
        let map = input.trimmingCharacters(in: .newlines)
            .components(separatedBy: .newlines)
            .reduce(into: [String: RecipeVal]()) { map, newLine in
                let temp = newLine.components(separatedBy: " => ")
                
                let ingrs: [(Int, String)] = temp[0].components(separatedBy: ", ").map { entry in
                    let comps = entry.components(separatedBy: .whitespaces)
                    
                    return (Int(comps[0])!, comps[1])
                }
                
                let keyComps = temp[1].components(separatedBy: .whitespaces)
                
                leftovers[keyComps[1]] = 0
                map[keyComps[1]] = RecipeVal(quant: Int(keyComps[0])!, ingrs: ingrs)
        }
        
        return String(oreToMake(name: "FUEL", quant: 1, map: map, leftovers: &leftovers))
    }
    
    static func oreToMake(name: String, quant: Int, map: [String: RecipeVal], leftovers: inout [String: Int]) -> Int {
        if name == "ORE" {
            return quant
        }
        
        let rec = map[name]!
        let required = quant - leftovers[name]!
        
        if required <= 0 {
            leftovers[name] = -required
            return 0
        }
        
        leftovers[name] = 0
        
        let mult = required % rec.quant == 0 ? required / rec.quant : required / rec.quant + 1
        
        var totalOre = 0
        for ing in rec.ingrs {
            totalOre += oreToMake(name: ing.1, quant: ing.0 * mult, map: map, leftovers: &leftovers)
        }
        
        leftovers[name]! += mult * rec.quant - required
        
        return totalOre
    }
    
    static func part2(_ input: String) -> String {
        var leftovers = [String: Int]()
        let map = input.trimmingCharacters(in: .newlines)
            .components(separatedBy: .newlines)
            .reduce(into: [String: RecipeVal]()) { map, newLine in
                let temp = newLine.components(separatedBy: " => ")
                
                let ingrs: [(Int, String)] = temp[0].components(separatedBy: ", ").map { entry in
                    let comps = entry.components(separatedBy: .whitespaces)
                    
                    return (Int(comps[0])!, comps[1])
                }
                
                let keyComps = temp[1].components(separatedBy: .whitespaces)
                
                leftovers[keyComps[1]] = 0
                map[keyComps[1]] = RecipeVal(quant: Int(keyComps[0])!, ingrs: ingrs)
        }
        
        let oreLimit = 1000000000000
        
        // Find upper bound
        var lb = 1
        var ub = 1
        var cost = 0
        while cost < oreLimit {
            cost = oreToMake(name: "FUEL", quant: ub, map: map, leftovers: &leftovers)

            for keyVal in leftovers {
                leftovers[keyVal.key] = 0
            }

            ub *= 2
        }
        
        var quant = 0
        var prevQuant = 1
        
        // Binary serch for the quant
        while true {
            quant = lb + ((ub - lb) / 2)
            
            if quant == prevQuant {
                break
            }
            
            prevQuant = quant
            
            cost = oreToMake(name: "FUEL", quant: quant, map: map, leftovers: &leftovers)
            
            for keyVal in leftovers {
                leftovers[keyVal.key] = 0
            }
            
            if cost > oreLimit {
                ub = quant - 1
            } else {
                lb = quant + 1
            }
        }
        
        return String(quant - 1)
    }
    
    struct RecipeVal {
        var quant: Int
        var ingrs: [(Int, String)]
    }
}
