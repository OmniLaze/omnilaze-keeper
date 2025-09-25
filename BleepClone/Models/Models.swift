import SwiftData
import Foundation

@Model
final class Room {
    @Attribute(.unique) var id: UUID
    var name: String
    var icon: RoomIcon
    var createdAt: Date
    var archived: Bool
    @Relationship(deleteRule: .cascade) var items: [Item]
    @Relationship(inverse: \Room.parent) var children: [Room]
    var parent: Room?

    init(name: String, icon: RoomIcon = .none, parent: Room? = nil) {
        self.id = UUID()
        self.name = name
        self.icon = icon
        self.createdAt = .now
        self.archived = false
        self.items = []
        self.children = []
        self.parent = parent
    }
}

enum RoomIcon: Codable {
    case none
    case emoji(String)
    case imageFile(String)
}

enum ItemKind: Codable {
    case note
    case link
    case image
}

@Model
final class Item {
    @Attribute(.unique) var id: UUID
    var kind: ItemKind
    var title: String
    var subtitle: String?
    var room: Room?
    var createdAt: Date
    var updatedAt: Date
    var archived: Bool
    var note: NotePayload?
    var link: LinkPayload?
    var image: ImagePayload?

    init(kind: ItemKind, title: String, subtitle: String? = nil, room: Room?) {
        self.id = UUID()
        self.kind = kind
        self.title = title
        self.subtitle = subtitle
        self.room = room
        self.createdAt = .now
        self.updatedAt = .now
        self.archived = false
    }
}

struct NotePayload: Codable {
    var markdown: String
}

struct LinkPayload: Codable {
    var url: URL
    var domain: String
    var summary: String?
    var imageFile: String?
}

struct ImagePayload: Codable {
    var imageFile: String
    var caption: String?
}
