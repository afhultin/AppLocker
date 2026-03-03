import Foundation

final class ProtectedAppsStore: ObservableObject {
    @Published var protectedBundleIDs: Set<String> { didSet { persist() } }
    @Published var lockOnEveryActivation: Bool { didSet { persist() } }

    private let defaults = UserDefaults.standard
    private let kIDs = "ProtectedBundleIDs"
    private let kEvery = "LockOnEveryActivation"

    init() {
        if let saved = defaults.array(forKey: kIDs) as? [String] {
            self.protectedBundleIDs = Set(saved)
        } else {
            self.protectedBundleIDs = []
        }
        self.lockOnEveryActivation = defaults.bool(forKey: kEvery)
    }

    private func persist() {
        defaults.set(Array(protectedBundleIDs), forKey: kIDs)
        defaults.set(lockOnEveryActivation, forKey: kEvery)
    }

    func isProtected(bundleID: String?) -> Bool {
        guard let id = bundleID else { return false }
        return protectedBundleIDs.contains(id)
    }

    func add(bundleID: String) { protectedBundleIDs.insert(bundleID) }
    func remove(bundleID: String) { protectedBundleIDs.remove(bundleID) }
}