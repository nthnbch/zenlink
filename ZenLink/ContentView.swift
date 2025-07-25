import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "link.circle.fill")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("ZenLink")
                .font(.largeTitle)
                .fontWeight(.semibold)
            Text("Nettoyage automatique des liens")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
