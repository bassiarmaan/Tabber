import SwiftUI
import SwiftData


struct ContentView: View {
    var body: some View {
        TabView {
            FirstTabView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            SecondTabView()
                .tabItem {
                    Label("Receipt", systemImage: "doc.text")
                }
            ThirdTabView(sharedDataModel: SharedDataModel())
                .tabItem {
                    Label("Single", systemImage: "person")
                }
            
            FourthTabView(sharedDataModel: SharedDataModel())
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
