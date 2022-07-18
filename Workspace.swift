import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

// MARK: - Project

// Local plugin loaded
let localHelper = LocalHelper(name: "MyPlugin")

let workspace = Workspace(
  name: "iOSUiSamples",
  projects: [
    .relativeToRoot("App"),
    .relativeToRoot("Modules/UiSampleList")
  ]
)
