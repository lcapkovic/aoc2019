//
//  Input.swift
//  AdventOfCode2016
//
//  Created by Lukas Capkovic on 27/11/2019.
//  Copyright © 2019 Lukas Capkovic. All rights reserved.
//

import Foundation

class Input {
    
    static let inputURL = URL(fileURLWithPath: #file).deletingLastPathComponent()
    
    static func get(_ file: String) throws -> String {
        let inputData = try Data(contentsOf: inputURL.appendingPathComponent(file))
        guard let input = String(data: inputData, encoding: .utf8) else {
            throw NSError() as Error
        }
        return input
    }
}
