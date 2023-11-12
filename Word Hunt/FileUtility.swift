//
//  FileUtility.swift
//  Word Hunt
//
//  Created by Sylvan Martin on 11/12/23.
//

import Foundation

class FileUtility {
    
    class func loadWords(into dictionary: inout Set<String>) {
        let task = Process()
        let pipe = Pipe()
        
//        let command = "cat \"/Users/sylvanm/Programming/Just for fun/wordlesolver/wordlesolver/words\" | grep \"\(expression)\""
        let command = "cat \"/usr/share/dict/words\""
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.launchPath = "/bin/zsh"
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        var words = output.split(separator: "\n").map { String($0) }
        
        for word in words {
            dictionary.insert(word)
        }
    }
    
}
