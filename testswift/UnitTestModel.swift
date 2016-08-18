//
//  UnitTestModel.swift
//  testswift
//
//  Created by ryan on 7/23/16.
//  Copyright © 2016 musicpang. All rights reserved.
//

import Foundation

struct UnitTestModel {
    let block: String
    let unitTestFuncName: String
}

extension UnitTestModel: Equatable {}
func ==(a: UnitTestModel, b: UnitTestModel) -> Bool {
    return a.unitTestFuncName == b.unitTestFuncName
}

extension UnitTestModel: Hashable {
    var hashValue: Int {
        return unitTestFuncName.hashValue
    }
}