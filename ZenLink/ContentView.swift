import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "link.circle.fill")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("app_name".localized)
                .font(.largeTitle)
                .fontWeight(.semibold)
            Text("subtitle".localized)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
