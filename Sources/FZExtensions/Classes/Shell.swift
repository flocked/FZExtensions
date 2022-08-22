//
//  ShellCommand.swift
//  FZExtensions
//
//  Created by Florian Zand on 07.06.22.
//

#if os(macOS)

import Foundation

struct Shell {
    struct Error: Swift.Error {
        let command: String
        let output: String?
        let message: String?
        let exitCode: Int32
    }
    
    enum ShellType: String {
        case bash
        case zsh
    }
    
    static func execute(_ args: String...,at path: String = ".", update: ((String) -> Void)?, completion: @escaping (Result<String, Shell.Error>) -> Void) {
        self.execute(args, at: path, update: update, completion: completion)
    }
    
    static func execute(_ args: [String],at path: String = ".", update: ((String) -> Void)?, completion: @escaping (Result<String, Shell.Error>) -> Void) {
        let task = Process()
        task.launchPath = "/bin/bash"
        let command = "cd \(path.escapingSpaces) && \(args.joined(separator: " "))"
        task.arguments = ["-c", command]
        
        let group = DispatchGroup()

        let outputPipe = Pipe()
        var outputData = Data()
        task.standardOutput = outputPipe
        
        group.enter()
        outputPipe.fileHandleForReading.readabilityHandler = { handle in
            let partialData = handle.availableData
            if partialData.isEmpty  {
                outputPipe.fileHandleForReading.readabilityHandler = nil
                group.leave()
            } else {
                let str = String(data: partialData, encoding: .utf8) ?? ""
                if (str.trimmingCharacters(in: .whitespacesAndNewlines) != "") {
                    update?(str)
                }
                outputData.append(partialData)
            }
        }

        let errorPipe = Pipe()
        task.standardError = errorPipe
        var errorData = Data()

        group.enter()
        errorPipe.fileHandleForReading.readabilityHandler = { handle in
            let partialData = handle.availableData
            if partialData.isEmpty  {
                errorPipe.fileHandleForReading.readabilityHandler = nil
                group.leave()
            } else {
                errorData.append(partialData)
            }
        }

        task.terminationHandler = { task in
            group.wait()
                if (task.terminationStatus != 0) {
                    let stdout = String(data: outputData, encoding: .utf8)
                    let stderr = String(data: errorData, encoding: .utf8)
                    completion(.failure(.init(command: command, output: stdout, message: stderr, exitCode: task.terminationStatus)))
                } else {
                    let str = String(data: outputData, encoding: .utf8) ?? ""
                    completion(.success(str))
                }
        }
        task.launch()
    }
    
    @discardableResult
    static func execute(_ args: String...,at path: String = ".") -> Result<String, Shell.Error> {
        return execute(args, at: path)
    }
    
    @discardableResult
    static func execute(_ args: [String],at path: String = ".") -> Result<String, Shell.Error> {
        let task = Process()
        task.launchPath = "/bin/bash"
        let command = "cd \(path.escapingSpaces) && \(args.joined(separator: " "))"
        task.arguments = ["-c", command]
        
        let group = DispatchGroup()

        let outputPipe = Pipe()
        var outputData = Data()
        task.standardOutput = outputPipe
        
        group.enter()
        outputPipe.fileHandleForReading.readabilityHandler = { handle in
            let partialData = handle.availableData
            if partialData.isEmpty  {
                outputPipe.fileHandleForReading.readabilityHandler = nil
                group.leave()
            } else {
                outputData.append(partialData)
            }
        }

        let errorPipe = Pipe()
        task.standardError = errorPipe
        var errorData = Data()

        group.enter()
        errorPipe.fileHandleForReading.readabilityHandler = { handle in
            let partialData = handle.availableData
            if partialData.isEmpty  {
                errorPipe.fileHandleForReading.readabilityHandler = nil
                group.leave()
            } else {
                errorData.append(partialData)
            }
        }
        task.launch()
        task.waitUntilExit()
        group.wait()
        if (task.terminationStatus != 0) {
            let stdout = String(data: outputData, encoding: .utf8)
            let stderr = String(data: errorData, encoding: .utf8)
            return .failure(.init(command: command, output: stdout, message: stderr, exitCode: task.terminationStatus))
        } else {
            let str = String(data: outputData, encoding: .utf8) ?? ""
            return .success(str)
        }
    }
    
}

private extension String {
  var escapingSpaces: String {
    return replacingOccurrences(of: " ", with: "\\ ")
  }
}

extension Shell.Error: CustomStringConvertible {
    public var description: String {
        return """
               ShellOut encountered an error
               Status code: \(exitCode)
               Message: "\(message ?? "")"
               Output: "\(output ?? "")"
               """
    }
}

#endif
