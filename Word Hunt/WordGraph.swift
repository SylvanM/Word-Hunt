//
//  WordGraph.swift
//  Word Hunt
//
//  Created by Sylvan Martin on 11/11/23.
//

import Foundation

class LetterNode {
    
    var letter: String
    
    var neighbors: [LetterNode]
    
    var coords: Coordinate
    
    init(letter: String, coord: Coordinate) {
        self.letter = letter
        self.neighbors = []
        self.coords = coord
    }
    
    
    
}

typealias Coordinate = (x: Int, y: Int)
typealias Path = [Coordinate]

struct WordGraph: CustomStringConvertible {
    
    var nodes: [[LetterNode]]
    
    var description: String {
        var desc = ""
        for line in nodes {
            desc += String(line.map({ Character($0.letter) })) + "\n"
        }
        return desc
    }
    
    init(letterLines: [String]) {
        let letterGrid = letterLines.map { Array($0) }
        
        nodes = [[LetterNode]](repeating: [LetterNode](repeating: LetterNode(letter: "empty", coord: (-1, -1)), count: letterGrid.first!.count), count: letterGrid.count)
        for i in 0..<nodes.count {
            for j in 0..<nodes[i].count {
                nodes[i][j] = LetterNode(letter: String(letterGrid[i][j]), coord: (i, j))
            }
        }
        
        for i in 0..<nodes.count {
            for j in 0..<nodes[i].count {
                for deltaI in [-1, 0, 1] {
                    for deltaJ in [-1, 0, 1] {
                        if deltaI == 0 && deltaJ == 0 { continue }
                        
                        // now add this node as a neighbor!
                        
                        if nodes.indices.contains(i + deltaI) {
                            let row = nodes[i + deltaI]
                            if row.indices.contains(j + deltaJ) {
                                nodes[i][j].neighbors.append(row[j + deltaJ])
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getWords(dictionary: inout Set<String>) -> [(word: String, path: Path)] {
        // Do a BFS to find words!
        
        var words: [String : Path] = [:]
        
        let startMatrix = [[Bool]](repeating: [Bool](repeating: false, count: nodes.first!.count), count: nodes.count)
        
        for row in nodes {
            for node in row {
                bfs(dictionary: &dictionary, fromNode: node, visitedMatrix: startMatrix, currentWord: node.letter, foundWords: &words, currentPath: [node.coords], withDepth: 1)
            }
        }
        
        // now we want to sort the words, by length!
        
        return words.sorted { a, b in
            a.key.count <= b.key.count
        }.map { (key: String, value: Path) in
            (key, value)
        }
    }
    
    func bfs(dictionary: inout Set<String>, fromNode node: LetterNode, visitedMatrix: [[Bool]], currentWord: String, foundWords: inout [String : Path], currentPath: [Coordinate], withDepth depth: Int) {
        if depth == 10 {
            return
        }
        
        var visited = visitedMatrix
        visited[node.coords.x][node.coords.y] = true
        
        
        // check if this is a word we haven't seen yet!
        if depth >= 3 {
            if !foundWords.keys.contains(where: { $0 == currentWord }) {
                if dictionary.contains(currentWord) {
                    foundWords[currentWord] = currentPath
                }
            }
        }
        
        for neighbor in node.neighbors {
            if visited[neighbor.coords.x][neighbor.coords.y] {
                continue
            }
            
            
            var newPath = currentPath
            newPath.append(neighbor.coords)
            bfs(dictionary: &dictionary, fromNode: neighbor, visitedMatrix: visited, currentWord: currentWord + neighbor.letter, foundWords: &foundWords, currentPath: newPath, withDepth: depth + 1)
        }
    }
    
}
