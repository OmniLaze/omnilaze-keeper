import SwiftUI

struct CardView: View {
    let item: Item

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            thumbnail
                .frame(height: 120)
                .frame(maxWidth: .infinity)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 16))

            Text(item.title)
                .font(.headline)
                .lineLimit(2)

            if let subtitle = item.subtitle, !subtitle.isEmpty {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            if let roomName = item.room?.name {
                Text(roomName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .contextMenu { ItemContextMenu(item: item) }
    }

    @ViewBuilder
    private var thumbnail: some View {
        switch item.kind {
        case .note:
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.15))
                Text(item.note?.markdown.prefix(120) ?? "")
                    .font(.callout)
                    .padding(10)
                    .lineLimit(5)
            }
        case .link:
            if let path = item.link?.imageFile, let image = UIImage(contentsOfFile: path) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.15))
                    .overlay(Image(systemName: "link").font(.title))
            }
        case .image:
            if let path = item.image?.imageFile, let image = UIImage(contentsOfFile: path) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.15))
            }
        }
    }
}

struct ItemContextMenu: View {
    let item: Item

    var body: some View {
        Button("Move…", systemImage: "folder") {}
        Button("Archive", systemImage: "archivebox") {}
        Divider()
        Button("Delete", systemImage: "trash", role: .destructive) {}
    }
}
