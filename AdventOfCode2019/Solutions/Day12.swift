//
//  Day12.swift
//  AdventOfCode2019
//
//  Created by Lukas Capkovic on 11/12/2019.
//  Copyright © 2019 Lukas Capkovic. All rights reserved.
//

import Foundation

class Day12: Day {
    static func part1(_ input: String) -> String {
        var moons = input.trimmingCharacters(in: .newlines)
            .components(separatedBy: .newlines)
            .map { $0.components(separatedBy: (CharacterSet.decimalDigits.union(CharacterSet(charactersIn: "-")).inverted)) }
            .map { $0.compactMap{ Int($0)} }
            .map { Moon(pos: ($0[0], $0[1], $0[2]), vel: (0,0,0)) }
            
        
        for _ in 0..<1000 {
            for i in 0..<moons.count {
                for j in i+1..<moons.count {
                                        
                    if moons[i].pos.x > moons[j].pos.x {
                        moons[i].vel.x -= 1
                        moons[j].vel.x += 1
                    } else if moons[i].pos.x < moons[j].pos.x {
                        moons[i].vel.x += 1
                        moons[j].vel.x -= 1
                    }
                    
                    if moons[i].pos.y > moons[j].pos.y {
                        moons[i].vel.y -= 1
                        moons[j].vel.y += 1
                    } else if moons[i].pos.y < moons[j].pos.y {
                        moons[i].vel.y += 1
                        moons[j].vel.y -= 1
                    }
                    
                    if moons[i].pos.z > moons[j].pos.z {
                        moons[i].vel.z -= 1
                        moons[j].vel.z += 1
                    } else if moons[i].pos.z < moons[j].pos.z {
                        moons[i].vel.z += 1
                        moons[j].vel.z -= 1
                    }
                }
            }
            
            for i in 0..<moons.count {
                moons[i].pos.x += moons[i].vel.x
                moons[i].pos.y += moons[i].vel.y
                moons[i].pos.z += moons[i].vel.z
            }
            
        }
        
        return String(moons.reduce(0, {
            let pot = ((abs($1.pos.x) + abs($1.pos.y) + abs($1.pos.z)))
            let kin =  ((abs($1.vel.x) + abs($1.vel.y) + abs($1.vel.z)))
            return $0 + pot * kin
        }))
    }
    
    static func part2(_ input: String) -> String {
        var moons = input.trimmingCharacters(in: .newlines)
            .components(separatedBy: .newlines)
            .map { $0.components(separatedBy: (CharacterSet.decimalDigits.union(CharacterSet(charactersIn: "-")).inverted)) }
            .map { $0.compactMap{ Int($0)} }
            .map { [Moon1D(p: $0[0], v: 0), Moon1D(p: $0[1], v: 0), Moon1D(p: $0[2], v: 0)] }
        
        let initial = (0..<3).map { Universe1D(m1: moons[0][$0], m2: moons[1][$0], m3: moons[2][$0], m4: moons[3][$0]) }
        var periods = [Int]()
                 
        for axis in 0..<3 {
            for iter in 0..<1000000 {
                for i in 0..<moons.count {
                    for j in i+1..<moons.count {
                        if moons[i][axis].p > moons[j][axis].p {
                            moons[i][axis].v -= 1
                            moons[j][axis].v += 1
                        } else if moons[i][axis].p < moons[j][axis].p {
                            moons[i][axis].v += 1
                            moons[j][axis].v -= 1
                        }
                    }
                    moons[i][axis].p += moons[i][axis].v
                    
                }
                
                let val = Universe1D(m1: moons[0][axis], m2: moons[1][axis], m3: moons[2][axis], m4: moons[3][axis])
                if val == initial[axis] {
                    periods.append(iter+1)
                    break
                }
            }
        }
        
        return "The answer is LCM of \(periods[0]), \(periods[1]), \(periods[2])"
    }
}

fileprivate struct Moon {
    var pos: (x: Int, y: Int, z: Int)
    var vel: (x: Int, y: Int, z: Int)
}

fileprivate struct Moon1D: Hashable {
    var p: Int
    var v: Int
}

fileprivate struct Universe1D: Hashable {
    var m1: Moon1D
    var m2: Moon1D
    var m3: Moon1D
    var m4: Moon1D
}
