import SwiftUI

struct NoteEditorView: View {
    @Bindable var item: Item
    @State private var text: String

    init(item: Item) {
        self.item = item
        _text = State(initialValue: item.note?.markdown ?? "")
    }

    var body: some View {
        TextEditor(text: $text)
            .padding()
            .navigationTitle(item.title.isEmpty ? "Note" : item.title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") { save() }
                }
            }
    }

    private func save() {
        item.title = title(from: text)
        item.note = .init(markdown: text)
        item.updatedAt = .now
    }

    private func title(from text: String) -> String {
        let firstLine = text.split(separator: "\n").first ?? "Note"
        return String(firstLine).trimmingCharacters(in: .whitespaces)
    }
}
