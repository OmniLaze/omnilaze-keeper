import SwiftUI
import SwiftData

struct NewRoomSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var name = ""
    @State private var icon: RoomIcon = .none

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                Picker("Icon", selection: Binding(
                    get: {
                        switch icon {
                        case .none:
                            return 0
                        case .emoji:
                            return 1
                        case .imageFile:
                            return 2
                        }
                    },
                    set: { index in
                        switch index {
                        case 1:
                            icon = .emoji("📁")
                        case 2:
                            icon = .imageFile("")
                        default:
                            icon = .none
                        }
                    }
                )) {
                    Text("None").tag(0)
                    Text("Emoji").tag(1)
                    Text("Image").tag(2)
                }
            }
            .navigationTitle("New Room")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save", action: save)
                }
            }
        }
    }

    private func save() {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        let room = Room(name: name, icon: icon)
        modelContext.insert(room)
        dismiss()
    }
}
