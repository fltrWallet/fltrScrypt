//===----------------------------------------------------------------------===//
//
// This source file is part of the fltrScrypt open source project
//
// Copyright (c) 2022 fltrWallet AG and the fltrScrypt project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//
import XCTest
import fltrScrypt

final class SwiftScryptTests: XCTestCase {
    func test01() throws {
        let result = try scrypt(password: "password".ascii,
                                salt: "NaCl".ascii,
                                parameters: .N(1024, r: 8, p: 16, length: 64))
        XCTAssertEqual(
            result.hex,
            "fdbabe1c9d3472007856e7190d01e9fe7c6ad7cbc8237830e77376634b3731622eaf30d92e22a3886ff109279d9830dac727afb94a83ee6d8360cbdfa2cc0640"
        )
    }
    
    func test02() throws {
        let result = try scrypt(password: "pleaseletmein".ascii,
                                salt: "SodiumChloride".ascii,
                                parameters: .N(16384, r: 8, p: 1, length: 64))
        XCTAssertEqual(
            result.hex,
            "7023bdcb3afd7348461c06cd81fd38ebfda8fbba904f8e3ea9b543f6545da1f2d5432955613f0fcf62d49705242a9af9e61e85dc0d651e40dfcf017b45575887")
    }
    
    func testThrows() {
        XCTAssertThrowsError(
            _ = try scrypt(password: "password".ascii, salt: "NaCl".ascii, parameters: .N(47, r: 1, p: 1, length: 64))
        )
    }
}

extension StringProtocol {
    var ascii: [UInt8] {
        self.map { $0.asciiValue! }
    }
}

extension Array where Element == UInt8 {
    var hex: String {
        self.map {
            String(format: "%02x", $0)
        }
        .joined()
    }
}
