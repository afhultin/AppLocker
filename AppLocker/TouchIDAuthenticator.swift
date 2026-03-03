import Foundation
import LocalAuthentication

final class TouchIDAuthenticator {
    static let shared = TouchIDAuthenticator()
    private init() {}

    func authenticate(reason: String = "Unlock protected app", completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        context.localizedFallbackTitle = "Use Password"
        var error: NSError?
        let policy: LAPolicy = .deviceOwnerAuthentication
        guard context.canEvaluatePolicy(policy, error: &error) else {
            DispatchQueue.main.async { completion(false) }
            return
        }
        context.evaluatePolicy(policy, localizedReason: reason) { success, _ in
            DispatchQueue.main.async { completion(success) }
        }
    }
}