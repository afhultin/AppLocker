import AppKit

extension NSRunningApplication {
    var icon: NSImage? {
        guard let url = bundleURL else { return nil }
        return NSWorkspace.shared.icon(forFile: url.path)
    }
}