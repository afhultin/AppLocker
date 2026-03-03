import SwiftUI

struct MenuBarView: View {
    @EnvironmentObject var store: ProtectedAppsStore
    @EnvironmentObject var controller: AppLockController
    @State private var showingPicker = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lock.shield")
                Text("AppLocker")
                    .font(.headline)
                Spacer()
                Button("Quit AppLocker") { NSApp.terminate(nil) }
            }.padding(.bottom, 6)

            Toggle(isOn: $store.lockOnEveryActivation) {
                Text("Lock every activation (re-auth when app re-launched)")
            }

            Divider()
            Text("Protected Apps")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if store.protectedBundleIDs.isEmpty {
                Text("No protected apps yet.")
                    .foregroundStyle(.secondary)
            } else {
                List(Array(store.protectedBundleIDs).sorted(), id: \.self) { bundleID in
                    HStack {
                        Text(bundleID)
                        Spacer()
                        Button(role: .destructive) {
                            store.remove(bundleID: bundleID)
                        } label: {
                            Image(systemName: "trash")
                        }.buttonStyle(.borderless)
                    }
                }.frame(minHeight: 140, maxHeight: 220)
            }

            HStack {
                Button { showingPicker = true } label: {
                    Label("Add from Running Apps", systemImage: "plus")
                }
                Spacer()
                Button {
                    if let s = NSPasteboard.general.string(forType: .string)?.trimmingCharacters(in: .whitespacesAndNewlines), !s.isEmpty {
                        store.add(bundleID: s)
                    }
                } label: {
                    Label("Add Bundle ID from Clipboard", systemImage: "doc.on.clipboard")
                }
            }
        }
        .padding(12)
        .sheet(isPresented: $showingPicker) {
            RunningAppsPicker { bundleID in
                store.add(bundleID: bundleID)
            }
            .frame(minWidth: 520, minHeight: 420)
        }
    }
}