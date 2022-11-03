// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "fltrScrypt",
    products: [
        .library(
            name: "fltrScrypt",
            targets: ["fltrScrypt"]),
    ],
    targets: [
        .target(
            name: "Clibscrypt",
            dependencies: [],
            path: "Sources/Clibscrypt",
            exclude: [ "b64.c",
                       "crypto_scrypt-check.c",
                       "crypto_scrypt-hash.c",
                       "crypto_scrypt-hexconvert.c",
                       "crypto-mcf.c",
                       "crypto-scrypt-saltgen.c",
                       "slowequals.c",
                       "README.md",
                       "LICENSE",
                       "Makefile",
                       "libscrypt.version",
                       "main.c", ],
            sources: [ "crypto_scrypt-nosse.c",
                       "sha256.c", ],
            publicHeadersPath: ".",
            cSettings: [ .headerSearchPath("."), ]),
        .target(
            name: "fltrScrypt",
            dependencies: [ "Clibscrypt", ]),
        .testTarget(
            name: "fltrScryptTests",
            dependencies: ["fltrScrypt"]),
    ]
)
