import ResourcePackage
import Spotlight
import SwiftUI

public struct SampleUiListView: View {
  public init() {}

  public var body: some View {
    NavigationView {
      List {
        NavigationLink("Spotlight") {
          SpotlightView()
        }
      }
      .navigationTitle("Sample UIs")
      .navigationBarTitleDisplayMode(.inline)
    }
    .enableInjection()
  }

  @ObserveInjection var inject
}
