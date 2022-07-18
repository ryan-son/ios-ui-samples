import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .framework(
  name: "UiSampleList",
  dependencies: [
    .target(name: "Spotlight")
  ],
  additionalTargets: [
    .spotlight
  ]
)
