import Foundation
import LinkPresentation
import UIKit

actor LinkPreviewService {
    static let shared = LinkPreviewService()

    func fetch(for url: URL) async throws -> (title: String, domain: String, summary: String?, imagePath: String?) {
        if let meta = try? await lpMetadata(for: url) {
            let title = meta.title ?? url.absoluteString
            let domain = url.host() ?? ""
            let summary = meta.value(forKey: "_summary") as? String
            let imagePath = await saveImage(from: meta)
            return (title, domain, summary, imagePath)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let html = String(decoding: data, as: UTF8.self)
        let title = match(html, pattern: "<meta property=\"og:title\" content=\"(.*?)\">") ?? url.absoluteString
        let domain = url.host() ?? ""
        let desc = match(html, pattern: "<meta property=\"og:description\" content=\"(.*?)\">")
        var imagePath: String?
        if let imageURLString = match(html, pattern: "<meta property=\"og:image\" content=\"(.*?)\">")
            , let imageURL = URL(string: imageURLString) {
            let (imageData, _) = try await URLSession.shared.data(from: imageURL)
            imagePath = try await ImageStore.shared.save(data: imageData, ext: "jpg")
        }
        return (title, domain, desc, imagePath)
    }

    private func lpMetadata(for url: URL) async throws -> LPLinkMetadata? {
        try await withCheckedThrowingContinuation { continuation in
            let provider = LPMetadataProvider()
            provider.startFetchingMetadata(for: url) { metadata, error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: metadata)
                }
            }
        }
    }

    private func match(_ html: String, pattern: String) -> String? {
        guard let regex = try? NSRegularExpression(
            pattern: pattern,
            options: [.dotMatchesLineSeparators, .caseInsensitive]
        ) else {
            return nil
        }
        let range = NSRange(location: 0, length: html.utf16.count)
        guard let match = regex.firstMatch(in: html, options: [], range: range), match.numberOfRanges > 1,
              let valueRange = Range(match.range(at: 1), in: html) else {
            return nil
        }
        return String(html[valueRange])
    }

    private func saveImage(from metadata: LPLinkMetadata) async -> String? {
        guard let provider = metadata.imageProvider else {
            return nil
        }
        do {
            let image = try await loadImage(from: provider)
            guard let data = image.jpegData(compressionQuality: 0.9) else {
                return nil
            }
            return try await ImageStore.shared.save(data: data, ext: "jpg")
        } catch {
            return nil
        }
    }

    private func loadImage(from provider: NSItemProvider) async throws -> UIImage {
        try await withCheckedThrowingContinuation { continuation in
            provider.loadObject(ofClass: UIImage.self) { object, error in
                if let error {
                    continuation.resume(throwing: error)
                } else if let image = object as? UIImage {
                    continuation.resume(returning: image)
                } else {
                    continuation.resume(throwing: NSError(
                        domain: "LinkPreviewService",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "Failed to load preview image"]
                    ))
                }
            }
        }
    }
}
