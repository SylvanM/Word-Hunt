//
//  main.swift
//  Word Hunt
//
//  Created by Sylvan Martin on 11/11/23.
//

import Foundation

var dictionary: Set<String> = .init()

print("Loading dictionary...")

FileUtility.loadWords(into: &dictionary)

print("Please enter, line by line, the letter grid.")

var letters = readLine(strippingNewline: true)

var lines: [String] = []

while letters != "" {
    lines.append(letters!)
    letters = readLine(strippingNewline: true)
}



let wordGraph = WordGraph(letterLines: lines)

let solutions = wordGraph.getWords(dictionary: &dictionary)
let words = solutions.map { (word: String, path: Path) in
    word
}

let grid = lines.map { line in
    Array(line)
}

print("Found \(words.count) words:")

for solution in solutions {
    let word = solution.word
    let path = solution.path
    
    print(word)
    for x in 0..<grid.count {
        for y in 0..<grid[x].count {
            
            var shouldCap = false
            
            for coord in path {
                if coord.x == x && coord.y == y {
                    shouldCap = true
                    break
                }
            }
            
            let letter = shouldCap ? grid[x][y].description.capitalized : grid[x][y].description
            
            print("\(letter) ", terminator: "")
        }
        print()
    }
    print()
    
}



