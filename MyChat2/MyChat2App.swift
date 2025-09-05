import SwiftUI
import SwiftData

// アプリの起点となるファイル
@main
struct MyChat2App: App {
    var sharedModelContainer: ModelContainer = {
            let schema = Schema([Message.self])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

            do {
                return try ModelContainer(for: schema, configurations: [modelConfiguration])
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }
        }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
