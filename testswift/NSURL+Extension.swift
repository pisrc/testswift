//
//  NSURL+Extension.swift
//  testswift
//
//  Created by ryan on 7/22/16.
//  Copyright © 2016 musicpang. All rights reserved.
//

import Foundation

extension NSURL {
    // 자식 url 인지 확인
    func hasChildUrl(url: NSURL) -> Bool {
        guard let parentPath = self.path else {
            return false
        }
        guard let childPath = url.path else {
            return false
        }
        if "\(childPath)/".hasPrefix("\(parentPath)/") {
            return true
        }
        return false
    }
}