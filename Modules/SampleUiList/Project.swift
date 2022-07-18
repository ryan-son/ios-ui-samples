import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .framework(
  name: "SampleUiList",
  dependencies: [
    .target(name: "Spotlight")
  ],
  additionalTargets: [
    .spotlight
  ]
)
