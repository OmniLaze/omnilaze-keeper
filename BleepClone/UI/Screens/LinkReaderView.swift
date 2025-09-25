import SwiftUI
import WebKit

struct LinkReaderView: View {
    let item: Item

    var body: some View {
        VStack(spacing: 0) {
            if let link = item.link {
                Header(link: link)
            }
            WebView(url: item.link?.url)
        }
        .navigationTitle(item.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    struct Header: View {
        let link: LinkPayload

        var body: some View {
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: "globe")
                VStack(alignment: .leading) {
                    Text(link.url.host() ?? "")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    if let summary = link.summary {
                        Text(summary)
                            .font(.footnote)
                            .lineLimit(2)
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(.thinMaterial)
        }
    }
}

struct WebView: UIViewRepresentable {
    let url: URL?

    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url {
            uiView.load(URLRequest(url: url))
        }
    }
}
