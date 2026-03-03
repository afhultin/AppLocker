import AppKit
import Combine

final class AppLockController: ObservableObject {
    @Published private(set) var lastBlockedAppName: String? = nil

    private var store: ProtectedAppsStore?
    private var allowedPIDs = Set<pid_t>()
    private var observers: [Any] = []

    func configure(with store: ProtectedAppsStore) {
        self.store = store
        startObserving()
    }

    private func startObserving() {
        stopObserving()
        let center = NSWorkspace.shared.notificationCenter
        let launchObs = center.addObserver(forName: NSWorkspace.didLaunchApplicationNotification, object: nil, queue: .main) { [weak self] n in
            self?.handleLaunch(n)
        }
        let termObs = center.addObserver(forName: NSWorkspace.didTerminateApplicationNotification, object: nil, queue: .main) { [weak self] n in
            self?.handleTerminate(n)
        }
        observers = [launchObs, termObs]
    }

    private func stopObserving() {
        let center = NSWorkspace.shared.notificationCenter
        observers.forEach { center.removeObserver($0) }
        observers.removeAll()
        allowedPIDs.removeAll()
    }

    private func handleLaunch(_ n: Notification) {
        guard let app = n.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication else { return }
        guard let store else { return }
        let bundleID = app.bundleIdentifier
        let pid = app.processIdentifier
        guard store.isProtected(bundleID: bundleID) else { return }
        guard !allowedPIDs.contains(pid) else { return }
        let appName = app.localizedName ?? (bundleID ?? "Unknown App")
        TouchIDAuthenticator.shared.authenticate(reason: "Unlock \(appName)") { [weak self] success in
            guard let self else { return }
            if success {
                self.allowedPIDs.insert(pid)
            } else {
                self.lastBlockedAppName = appName
                if !app.terminate() {
                    _ = app.forceTerminate()
                }
            }
        }
    }

    private func handleTerminate(_ n: Notification) {
        guard let app = n.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication else { return }
        allowedPIDs.remove(app.processIdentifier)
    }
}