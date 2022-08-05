import ResourcePackage
import SwiftUI

public struct SpotlightView: View {
  public init() {}
  
  public var body: some View {
    ScrollView {
      
      Text("This is Spotlight View")
        .padding()
        .navigationTitle("Spotlight View")
        .navigationBarTitleDisplayMode(.inline)
    }
    .enableInjection()
  }
  
  @ObserveInjection var inject
}

struct SpotlightView_Previews: PreviewProvider {
  static var previews: some View {
    SpotlightView()
  }
}
