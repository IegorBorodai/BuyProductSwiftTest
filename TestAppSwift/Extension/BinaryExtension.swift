//
//  BinaryExtension.swift
//  toFrom
//
//  Created by Iegor Borodai on 11/20/15.
//  Copyright © 2015 Iegor Borodai. All rights reserved.
//

import Foundation

infix operator ?= { associativity right precedence 90 }

func ?=<T>(inout left: T, right: T?) {
    if let value = right {
        left = value
    }
}

func ?=<T>(inout left: T?, right: T?) {
    if let value = right {
        left = value
    }
}