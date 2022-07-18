import ResourcePackage
import Spotlight
import SwiftUI

public struct UiSampleListView: View {
  public init() {}

  public var body: some View {
    NavigationView {
      List {
        NavigationLink("Spotlight") {
          SpotlightView()
        }
      }
      .navigationTitle("iOS UI Samples")
    }
    .enableInjection()
  }

  @ObserveInjection var inject
}

struct UiSampleListView_Previews: PreviewProvider {
  static var previews: some View {
    UiSampleListView()
  }
}
