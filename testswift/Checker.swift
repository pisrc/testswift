//
//  Checker.swift
//  testswift
//
//  Created by ryan on 7/22/16.
//  Copyright © 2016 musicpang. All rights reserved.
//

import Foundation

struct Checker {
    let rootDir: NSURL
    var rootPath: String {
        return rootDir.path ?? ""
    }
    
    init(path: String) {
        rootDir = NSURL(fileURLWithPath: path)
    }
    
    func check() -> Bool {
        var success = true
        let fileManager = NSFileManager()
        guard let enumerator = fileManager.enumeratorAtURL(rootDir,
                                                           includingPropertiesForKeys: [NSURLNameKey],
                                                           options: .SkipsHiddenFiles,
                                                           errorHandler: nil) else {
            return false
        }
        for url in enumerator {
            let path = url.path ?? ""
            if !path.lowercaseString.hasSuffix(".swift") {
                continue
            }
            
            let viewDir = rootDir.URLByAppendingPathComponent("view", isDirectory: true)
            if let dir = url.URLByDeletingLastPathComponent where viewDir.hasChildUrl(dir!) {
                // remove view directory
                continue
            }
            
            if !checkFilePath(path) {
                success = false
            }
        }
        
        return success
    }
    
    private func checkFilePath(path: String) -> Bool {
        
        var success = true
        let unitTests = Parser(path: path).parse()
        
        // test file check
        if 0 < unitTests.count {
            let testPath = getTestPathForPath(path)
            
            // exist check
            if !NSFileManager.defaultManager().fileExistsAtPath(testPath) {
                print("\(testPath) is not exist.")
                return false
            }
            
            // test source 안에 unitTest 가 존재 해야한다.
            do {
                let testSource = try NSString(contentsOfFile: testPath, encoding: NSUTF8StringEncoding) as String
                let notExists = try unitTests.filter { (unitTestModel) -> Bool in
                    let contains = try testSource.containsRegex("func .*\(unitTestModel.unitTestFuncName)[\\(| ]")
                    return !contains
                    }
                if 0 < notExists.count {
                    success = false
                    print("In \(testPath)")
                    notExists.forEach { (unitTestModel) in
                        print(" \(unitTestModel.unitTestFuncName) is not exist.")
                    }
                }
            } catch {
                print(error)
            }
        }
        return success
    }
    
    private func getTestPathForPath(path: String) -> String {
        if let last = rootDir.lastPathComponent, let testRoot = rootDir.URLByDeletingLastPathComponent?.URLByAppendingPathComponent("\(last)Tests").path {
            let subPath = path.stringByReplacingOccurrencesOfString(rootPath, withString: "").stringByReplacingOccurrencesOfString(".swift", withString: "Tests.swift")
            return testRoot + subPath
        }
        return path
    }
}