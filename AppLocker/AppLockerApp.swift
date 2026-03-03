import SwiftUI

@main
struct AppLockerApp: App {
    @StateObject private var store = ProtectedAppsStore()
    @StateObject private var controller = AppLockController()

    var body: some Scene {
        MenuBarExtra("AppLocker", systemImage: "lock.fill") {
            MenuBarView()
                .environmentObject(store)
                .environmentObject(controller)
        }
        .menuBarExtraStyle(.window)
        .onAppear {
            controller.configure(with: store)
        }

        Settings {
            MenuBarView()
                .frame(minWidth: 520, minHeight: 420)
                .environmentObject(store)
                .environmentObject(controller)
        }
    }
}