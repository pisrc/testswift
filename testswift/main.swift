//
//  main.swift
//  testswift
//
//  Created by ryan on 7/22/16.
//  Copyright © 2016 musicpang. All rights reserved.
//

import Foundation


enum Opt {
    case Help
    case Check(String)
    case TestCode(String)
}

var opt = Opt.Help

if 1 < Process.arguments.count {
    let o = Process.arguments[1]
    if o == "--check" {
        if 2 < Process.arguments.count {
            opt = Opt.Check(Process.arguments[2])
        }
    } else if o == "--testcode" {
        if 2 < Process.arguments.count {
            opt = Opt.TestCode(Process.arguments[2])
        }
    }
}

switch opt {
case .Help:
    print("testswift - v0.9.0\n")
    print("usage: testswift --check [target root path]")
    print("   or: testswift --testcode [source path]")
    print("   or: testswift -h  or  --help               Print Help (this message)")
case .Check(let path):
    if !Checker(path: path).check() {
        exit(-1)    // error
    }
case .TestCode(let sourcePath):
    let unitTestCode = TestCode(sourcePath: sourcePath).generate()
    print(unitTestCode)
}


