//
//  Day6.swift
//  AdventOfCode2019
//
//  Created by Lukas Capkovic on 06/12/2019.
//  Copyright © 2019 Lukas Capkovic. All rights reserved.
//

import Foundation

class Day6: Day {
    
    static func part1(_ input: String) -> String {
        let orbits = input.trimmingCharacters(in: .newlines)
            .components(separatedBy: .newlines)
            .map { $0.components(separatedBy: CharacterSet(charactersIn: ")")) }
        
        let orbitMap = orbits.reduce(into: [String: [String]]()) { map, pair in
            if map[pair[0]] == nil {
                map[pair[0]] = [pair[1]]
            } else {
                map[pair[0]]!.append(pair[1])
            }
        }
        
        return String(countOrbits(start: "COM", map: orbitMap, depth: 0))
    }
    
    static func part2(_ input: String) -> String {
        let orbits = input.trimmingCharacters(in: .newlines)
            .components(separatedBy: .newlines)
            .map { $0.components(separatedBy: CharacterSet(charactersIn: ")")) }
        
        let orbitMap = orbits.reduce(into: [String:String]()) { map, pair in
            map[pair[1]] = pair[0]
        }
        
        let youRoute = routeToCom(start: orbitMap["YOU"]!, map: orbitMap)
        let sanRoute = routeToCom(start: orbitMap["SAN"]!, map: orbitMap)
        
        for trans in youRoute {
            if sanRoute.contains(trans) {
                return String(youRoute.firstIndex(of: trans)! + sanRoute.firstIndex(of: trans)! + 2)
            }
        }
        
        return ""
    }
    
    static func countOrbits(start: String, map: [String: [String]], depth: Int) -> Int {
        if map[start] == nil {
            return depth
        } else {
            return depth + map[start]!.reduce(0) {
                $0 + countOrbits(start: $1, map: map, depth: depth + 1)
            }
        }
    }
    
    static func routeToCom(start: String, map: [String: String]) -> [String] {
        if map[start]! == "COM" {
            return ["COM"]
        } else {
            return [map[start]!] + routeToCom(start: map[start]!, map: map)
        }
    }
}
