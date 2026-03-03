import SwiftUI
import AppKit

struct RunningAppsPicker: View {
    @Environment(\.dismiss) private var dismiss
    let onPick: (String) -> Void
    @State private var apps: [NSRunningApplication] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Pick a Running App")
                    .font(.headline)
                Spacer()
                Button("Close") { dismiss() }
            }
            List(apps, id: \.processIdentifier) { app in
                HStack {
                    if let icon = app.icon {
                        Image(nsImage: icon).resizable().frame(width: 18, height: 18)
                    }
                    Text(app.localizedName ?? (app.bundleIdentifier ?? "Unknown"))
                    Spacer()
                    Text(app.bundleIdentifier ?? "(no bundle id)")
                        .foregroundStyle(.secondary)
                    Button("Protect") {
                        if let id = app.bundleIdentifier { onPick(id) }
                    }.buttonStyle(.bordered)
                }
            }.frame(minHeight: 300)
            HStack { Spacer(); Button("Refresh") { loadApps() } }
        }
        .padding(12)
        .onAppear(perform: loadApps)
    }

    private func loadApps() {
        let running = NSWorkspace.shared.runningApplications
            .filter { $0.activationPolicy == .regular }
            .sorted { ($0.localizedName ?? "") < ($1.localizedName ?? "") }
        apps = running
    }
}