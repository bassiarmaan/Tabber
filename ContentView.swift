import SwiftUI
import SwiftData

struct ContentView: View {
    // Create one shared instance of SharedDataModel to pass to all views
    @StateObject var sharedDataModel = SharedDataModel()

    var body: some View {
        TabView {
            FirstTabView(sharedDataModel: sharedDataModel)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            SecondTabView()
                .tabItem {
                    Label("Receipt", systemImage: "doc.text")
                }

            ThirdTabView(sharedDataModel: sharedDataModel)  // Use the shared instance
                .tabItem {
                    Label("Single", systemImage: "person")
                }
            
            FourthTabView(sharedDataModel: sharedDataModel)  // Use the same shared instance
                .tabItem {
                    Label("Group", systemImage: "person.3")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
