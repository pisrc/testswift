//
//  TestCode.swift
//  testswift
//
//  Created by ryan on 7/22/16.
//  Copyright © 2016 musicpang. All rights reserved.
//

import Foundation

struct TestCode {
    let sourcePath: String
    
    init(sourcePath: String) {
        self.sourcePath = sourcePath
    }
    
    func generate() -> String {
        
        return Parser(path: sourcePath).parse().map { (unitTestModel) -> String in
            let assert = "XCTAssert(true, \"It does not need to be tested.\")"
            return "func \(unitTestModel.unitTestFuncName)() {\n\(assert)\n}"
            }
            .joinWithSeparator("\n\n")
    }
}