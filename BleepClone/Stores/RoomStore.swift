import SwiftData

struct RoomSeeder {
    static func seedIfNeeded(modelContext: ModelContext) {
        let descriptor = FetchDescriptor<Room>()
        if let count = try? modelContext.fetchCount(descriptor), count == 0 {
            let inspiration = Room(name: "Inspiration")
            let journal = Room(name: "Journal")
            modelContext.insert(inspiration)
            modelContext.insert(journal)

            let note = Item(kind: .note, title: "Hi 👋", room: inspiration)
            note.note = .init(markdown: """
            # Hi 👋
            This is a note. In Bleep, you have flexibility to write detailed thoughts, but also save articles, movies to watch (or any bookmark really) as well as images that you can collect and curate.

            ## Get Started
            - Read this note, or at least skim it!
            - Save a link: maybe a TV show you want to watch?
            - Take a picture and save it here
            - Write a list of things you got done this week
            """)
            modelContext.insert(note)
        }
    }
}
