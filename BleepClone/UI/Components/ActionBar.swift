import SwiftUI

struct ActionBar: View {
    var onNewNote: () -> Void
    var onAddLink: () -> Void
    var onAddImage: () -> Void

    var body: some View {
        HStack(spacing: 28) {
            Button(action: onNewNote) { Image(systemName: "square.and.pencil") }
            Button(action: onAddLink) { Image(systemName: "link.badge.plus") }
            Button(action: onAddImage) { Image(systemName: "photo.on.rectangle") }
        }
        .font(.title2)
        .padding(.horizontal, 26)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial, in: Capsule())
        .shadow(radius: 6, y: 2)
        .frame(maxWidth: .infinity)
    }
}
