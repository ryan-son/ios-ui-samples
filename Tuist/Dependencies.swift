//
//  Dependencies.swift
//  Config
//
//  Created by Geonhee on 2022/07/18.
//

import ProjectDescription

let dependencies = Dependencies(
  carthage: nil,
  swiftPackageManager: [
    .remote(url: "https://github.com/krzysztofzablocki/Inject.git", requirement: .upToNextMajor(from: "1.0.0")),
    .remote(url: "https://github.com/CodeSlicing/pure-swift-ui.git", requirement: .upToNextMajor(from: "3.0.0"))
  ],
  platforms: [.iOS]
)
