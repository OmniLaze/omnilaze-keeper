import SwiftUI
import SwiftData

@main
struct BleepCloneApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: [Room.self, Item.self])
    }
}
