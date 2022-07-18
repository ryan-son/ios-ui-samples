import ProjectDescription

extension Target {
  public static let spotlight: Self = .staticLibrary(name: "Spotlight")
}

extension Array where Element == TargetDependency {}

enum ProjectDescription {
  static let organization: String = "ryan-son"
  static let deploymentTarget: DeploymentTarget = .iOS(targetVersion: "14.0", devices: [.iphone, .ipad])

  static func bundleId(for module: String) -> String {
    return "com.ryan-son.\(module)"
  }

  static func sourcePath(for target: String) -> SourceFilesList {
    return [.glob(.relativeToRoot("Modules/\(target)/Sources/**"))]
  }

  static func resourcePath(for target: String) -> ResourceFileElements {
    return ["Modules/\(target)/Resources/**"]
  }
}

extension Project {
  
  public static func app(
    name: String,
    packages: [Package] = [],
    dependencies: [TargetDependency]
  ) -> Project {
    let mainTarget: Target = .app(
      name: name,
      dependencies: dependencies
    )
    return Project(
      name: name,
      organizationName: ProjectDescription.organization,
      options: .options(disableSynthesizedResourceAccessors: true),
      packages: packages,
      targets: [mainTarget]
    )
  }
  
  public static func framework(
    name: String,
    packages: [Package] = [],
    dependencies: [TargetDependency],
    additionalTargets: [Target] = [],
    needsInject: Bool = true
  ) -> Project {
    let mainTarget: Target = .framework(
      name: name,
      dependencies: dependencies,
      needsInject: false
    )
    return Project(
      name: name,
      organizationName: ProjectDescription.organization,
      options: .options(disableSynthesizedResourceAccessors: true),
      packages: packages,
      settings: needsInject
      ? .settings(debug: ["OTHER_LDFLAGS": "-Xlinker -interposable"])
      : .settings(),
      targets: [mainTarget] + additionalTargets
    )
  }
  
  public static func resourcePackageFramework() -> Project {
    let name = "ResourcePackage"
    let mainTarget = Target(
      name: name,
      platform: .iOS,
      product: .framework,
      bundleId: ProjectDescription.bundleId(for: name),
      deploymentTarget: ProjectDescription.deploymentTarget,
      sources: ProjectDescription.sourcePath(for: name),
      resources: ["../\(name)/Resources/**"],
      scripts: [.swiftGen],
      dependencies: [
        .external(name: "Inject"),
        .external(name: "PureSwiftUI")
      ],
      additionalFiles: ["Templates"]
    )
    return Project(
      name: name,
      organizationName: ProjectDescription.organization,
      options: .options(disableSynthesizedResourceAccessors: true),
      targets: [mainTarget],
      additionalFiles: ["Templates"]
    )
  }
}

extension Target {
  public static func app(
    name: String,
    dependencies: [TargetDependency]
  ) -> Target {
    return Target(
      name: name,
      platform: .iOS,
      product: .app,
      bundleId: ProjectDescription.bundleId(for: name),
      deploymentTarget: ProjectDescription.deploymentTarget,
      infoPlist: .extendingDefault(with: InfoPlist.app),
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      scripts: [.swiftlint],
      dependencies: dependencies,
      additionalFiles: [".swiftlint.yml"]
    )
  }
  
  public static func framework(
    name: String,
    dependencies: [TargetDependency],
    needsInject: Bool
  ) -> Target {
    return Target(
      name: name,
      platform: .iOS,
      product: .framework,
      bundleId: ProjectDescription.bundleId(for: name),
      deploymentTarget: ProjectDescription.deploymentTarget,
      sources: ProjectDescription.sourcePath(for: name),
      scripts: [.swiftlint],
      dependencies: needsInject
      ? dependencies + [.external(name: "Inject")]
      : dependencies,
      settings: needsInject
      ? .settings(debug: ["OTHER_LDFLAGS": "Xlinker -interposable"])
      : .settings()
    )
  }
  
  public static func staticLibrary(
    name: String,
    dependencies: [TargetDependency] = [],
    needsResourcePackage: Bool = true
  ) -> Target {
    return Target(
      name: name,
      platform: .iOS,
      product: .staticLibrary,
      bundleId: ProjectDescription.bundleId(for: name),
      deploymentTarget: ProjectDescription.deploymentTarget,
      sources: [.glob(.relativeToRoot("Modules/\(name)/**"))],
      scripts: [.swiftlint],
      dependencies: needsResourcePackage
      ? dependencies + [.project(target: "ResourcePackage", path: .relativeToRoot("Modules/ResourcePackage"))]
      : dependencies,
      settings: .settings(debug: ["OTHER_LDFLAGS": "Xlinker -interposable"])
    )
  }
}

extension InfoPlist {
  static let app: [String: InfoPlist.Value] = [
    "CFBundleShortVersionString": "1.0",
    "CFBundleVersion": "1",
    "UIMainStoryboardFile": "",
    "UILaunchStoryboardName": "LaunchScreen"
  ]
}

extension TargetScript.Script {
  static let swiftlint = """
  if test -d "/opt/homebrew/bin/"; then
    PATH="/opt/homebrew/bin/:${PATH}"
  fi

  export PATH

  if which swiftlint >/dev/null; then
    swiftlint
  else
    echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
  fi
  """
  
  static let swiftGen = """
  if test -d "/opt/homebrew/bin/"; then
    PATH="/opt/homebrew/bin/:${PATH}"
  fi

  export PATH

  swiftgen run xcassets "${SRCROOT}/Resources/Colors.xcassets" "${SRCROOT}/Resources/Images.xcassets" -p "${SRCROOT}/Templates/Assets.stencil" --param publicAccess -o "${SRCROOT}/Sources/Assets+Derived.swift"
  """
}

extension TargetScript {
  static let swiftlint: Self = .pre(script: Script.swiftlint, name: "SwiftLint")
  static let swiftGen: Self = .pre(script: Script.swiftGen, name: "SwiftGen")
}
