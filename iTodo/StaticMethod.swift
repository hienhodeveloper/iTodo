//
//  StaticMethod.swift
//  iTodo
//
//  Created by Hien Ho on 1/14/20.
//  Copyright © 2020 TeamLuna. All rights reserved.
//

import Foundation

public func Init<T>(value: T, block: (_ object: T) -> Void) -> T {
    block(value)
    return value
}
