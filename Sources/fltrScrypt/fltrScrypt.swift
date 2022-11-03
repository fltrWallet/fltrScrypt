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
import Clibscrypt

public struct ScryptInternalError: Error {
    @usableFromInline init() {}
}

public struct ScryptParameters {
    public let N: UInt64
    public let r: UInt32
    public let p: UInt32
    public let length: Int
    
    @usableFromInline
    init(N: UInt64, r: UInt32, p: UInt32, length: Int) {
        self.N = N
        self.r = r
        self.p = p
        self.length = length
    }

    @inlinable
    public static func N(_ N: UInt64, r: UInt32, p: UInt32, length: Int) -> Self {
        ScryptParameters(N: N, r: r, p: p, length: length)
    }
}

extension ScryptParameters {
    public static let bip38nonmul: Self = .N(16384, r: 8, p: 8, length: 64)
    public static let bip38intermediate: Self = .N(16384, r: 8, p: 8, length: 32)
    public static let bip38mul: Self = .N(1024, r: 1, p: 1, length: 64)
}

@inlinable
public func scrypt(password: [UInt8],
                   salt: [UInt8],
                   parameters: ScryptParameters) throws -> [UInt8] {
    try Array(unsafeUninitializedCapacity: parameters.length) { buffer, setSizeTo in
        let cRet = password.withUnsafeBufferPointer { password in
            salt.withUnsafeBufferPointer { salt in
                libscrypt_scrypt(password.baseAddress!, password.count,
                                 salt.baseAddress!, salt.count,
                                 parameters.N, parameters.r, parameters.p,
                                 buffer.baseAddress!, parameters.length)
            }
        }
        
        guard cRet == 0
        else {
            throw ScryptInternalError()
        }
        setSizeTo = parameters.length
    }
}
