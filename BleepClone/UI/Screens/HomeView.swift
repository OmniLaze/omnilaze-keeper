import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Room.createdAt) private var rooms: [Room]
    @State private var selection: Segment = .everything

    enum Segment: String, CaseIterable {
        case everything
        case bookmarks
        case notes
        case images
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("", selection: $selection) {
                    ForEach(Segment.allCases, id: \.self) { segment in
                        Text(segment.rawValue.capitalized).tag(segment)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(filteredItems()) { item in
                            NavigationLink(value: item) {
                                CardView(item: item)
                            }
                        }
                    }
                    .padding()
                }
                .navigationTitle(selection.rawValue.capitalized)
                .navigationDestination(for: Item.self) { item in
                    ItemDestination(item: item)
                }

                ActionBar(
                    onNewNote: { createNote(in: nil) },
                    onAddLink: { /* present link sheet */ },
                    onAddImage: { /* present photos picker */ }
                )
                .padding()
            }
            .task {
                RoomSeeder.seedIfNeeded(modelContext: modelContext)
            }
        }
    }

    private func filteredItems() -> [Item] {
        let all = rooms.flatMap { $0.items }.filter { !$0.archived }
        switch selection {
        case .everything:
            return all
        case .bookmarks:
            return all.filter { $0.kind == .link }
        case .notes:
            return all.filter { $0.kind == .note }
        case .images:
            return all.filter { $0.kind == .image }
        }
    }

    private func createNote(in room: Room?) {
        let item = Item(kind: .note, title: "", room: room)
        item.note = .init(markdown: "")
        modelContext.insert(item)
    }
}

private struct ItemDestination: View {
    let item: Item

    var body: some View {
        switch item.kind {
        case .note:
            NoteEditorView(item: item)
        case .link:
            LinkReaderView(item: item)
        case .image:
            ImageViewerView(item: item)
        }
    }
}
