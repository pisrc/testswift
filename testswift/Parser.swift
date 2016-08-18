//
//  Parser.swift
//  testswift
//
//  Created by ryan on 7/23/16.
//  Copyright © 2016 musicpang. All rights reserved.
//

import Foundation

struct Parser {
    
    let path: String
    
    init (path: String) {
        self.path = path
    }
    
    func parse() -> [UnitTestModel] {
        do {
            let source = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding) as String
            return parseSource(source)
        } catch {}
        return []
    }
    
    
    private func nameOfBlock(block: String) -> String {
        do {
            let matches = try block.componentsSeparatedByString("{").first?.matches("[struct|class|extension] (.+)")
            if let matches = matches where 0 < matches.count {
                return matches[0]
            }
        } catch {}
        return block
    }
    
    private func unitTestsForBlocks(blocks: [String]) -> [UnitTestModel] {
        return unitTestsForBlocks(blocks, type: "func")
    }
    
    private func unitTestsForBlocks(blocks: [String], type: String) -> [UnitTestModel] {
        return blocks.filter { (block) -> Bool in
            guard let firstLine = block.componentsSeparatedByString("\n").first else {
                return false
            }
            if firstLine.containsString("\(type) ") {
                return true
            }
            return false
            }
            .map { (funcBlock) -> UnitTestModel in
                return UnitTestModel(
                    block: funcBlock,
                    unitTestFuncName: unitTestNameFromBlock(funcBlock)
                    )
            }
    }
    
    private func parseSource(source: String) -> [UnitTestModel] {
        
        let blocks = rootBlocksFromSource(source)
        let structs = blocks.filter { (block) -> Bool in
            guard let firstLine = block.componentsSeparatedByString("\n").first else {
                return false
            }
            if firstLine.containsString("struct ") || firstLine.containsString("class ") || firstLine.containsString("extension ") {
                return true
            }
            return false
            }
        
        // root에 위치하는 func unitTests
        let rootUnitTests = unitTestsForBlocks(blocks)
        
        // struct, class, extension 안의 unitTest 들
        let tests = structs.map { (structBlock) -> [UnitTestModel] in
            //let structName = nameOfBlock(structBlock)
            let blocks = rootBlocksFromSource(innerTextFromBlock(structBlock))
            let unitTests = unitTestsForBlocks(blocks)
            return unitTests
            }
            .flatMap { $0 }
        
        let allTests = rootUnitTests + tests
        return Array(Set(allTests)) // 중복 제거
    }
    
    
    // example,
    // func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // testApplication_didFinishLaunchingWithOptions
    private func getUnitTestNameForFuncName(funcName: String) -> String {
        var unitTestName = ""
        do {
            let matches = try funcName.matches("func ([^:]+)\\((.*)\\)")
            if 0 < matches.count {
                unitTestName += matches[0].trim()
            }
            if 1 < matches.count {
                let pnames = matches[1].componentsSeparatedByString(",")
                    .map { (param) -> String in
                        let headAndTail = param.componentsSeparatedByString(":").map { $0.trim() }
                        var pname = ""
                        if 0 < headAndTail.count {
                            let head = headAndTail[0]
                            let exNameInName = head.componentsSeparatedByString(" ").map { $0.trim() }
                            if 0 < exNameInName.count {
                                let exName = exNameInName[0]
                                pname = exName
                            } else {
                                pname = head
                            }
                        }
                        return pname
                    }
                    .filter { 0 < $0.characters.count }
                for (_, pname) in pnames.enumerate() {
                    unitTestName += "_\(pname)"
                }
            }
        } catch {}
        
        // 함수명에으로 쓰이면 안되는 문자열들은 대체
        unitTestName = unitTestName.stringByReplacingOccurrencesOfString("==", withString: "EE")
        unitTestName = unitTestName.stringByReplacingOccurrencesOfString("<", withString: "LT")
        
        return "test" + unitTestName.capitalizeFirst
    }
    
    private func unitTestNameFromBlock(block: String) -> String {
        
        let headAndTail = block.componentsSeparatedByString("{")
        if 0 < headAndTail.count {
            let head = headAndTail[0].trim()
            return getUnitTestNameForFuncName(head)
        }
        return block
    }
    
    private func innerTextFromBlock(fullBlock: String) -> String {
        let s = fullBlock.rangeOfString("{")
        let e = fullBlock.rangeOfString("}", options: NSStringCompareOptions.BackwardsSearch, range: nil, locale: nil)
        if let s = s, let e = e {
            let range = (s.startIndex.advancedBy(1) ..< e.startIndex)
            return fullBlock.substringWithRange(range)
        }
        return fullBlock
    }
    
    private func rootBlocksFromSource(source: String) -> [String] {
        
        // 전체 source text에서 최상위 block 으로 나눕니다.
        var parents: [String] = []
        var brace = 0
        var parentName: String? = nil
        var body: String? = nil
        var line = ""
        for char in source.characters {
            
            if char == "\n" {
                body? += line + "\n"
                line = ""
            } else {
                line.append(char)
            }
            
            if char == "{" {
                brace += 1
            } else if char == "}" {
                brace -= 1
            }
            
            // 구조체 이름
            if brace == 1 && parentName == nil {
                parentName = line
                body = ""
            } else if brace == 0 && parentName != nil {
                
                if let body = body {
                    parents.append((body + line).trim())
                }
                
                parentName = nil
                body = nil
            }
            
        }
        return parents
    }
}
