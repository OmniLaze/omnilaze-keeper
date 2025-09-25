import SwiftUI

struct RoomView: View {
    @Bindable var room: Room
    @State private var query = ""

    var body: some View {
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
        .navigationTitle(room.name)
        .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("Select Items", systemImage: "checkmark.circle") {}
                    Button("Edit Room", systemImage: "pencil") {}
                    Button("Add Sub-Room", systemImage: "folder.badge.plus") {}
                    Button("Move…", systemImage: "folder") {}
                    Button("Archive", systemImage: "archivebox") {}
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        }
    }

    private func filteredItems() -> [Item] {
        let base = room.items.filter { !$0.archived }
        guard !query.isEmpty else {
            return base
        }
        return base.filter { item in
            item.title.localizedCaseInsensitiveContains(query)
                || (item.subtitle ?? "").localizedCaseInsensitiveContains(query)
        }
    }
}
