import Foundation

actor ImageStore {
    static let shared = ImageStore()

    private let directory: URL = {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        let directory = base.appending(path: "Images", directoryHint: .isDirectory)
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        return directory
    }()

    func save(data: Data, ext: String) throws -> String {
        let url = directory.appending(path: UUID().uuidString + "." + ext)
        try data.write(to: url)
        return url.path
    }
}
