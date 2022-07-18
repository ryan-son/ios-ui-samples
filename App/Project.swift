import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

let project = Project.app(
  name: "iOSUiSamples",
  dependencies: [
    .project(target: "UiSampleList", path: .relativeToManifest("../Modules/UiSampleList"))
  ]
)
