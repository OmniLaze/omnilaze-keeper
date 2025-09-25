import SwiftUI

struct ImageViewerView: View {
    let item: Item

    var body: some View {
        GeometryReader { proxy in
            if let path = item.image?.imageFile, let image = UIImage(contentsOfFile: path) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .background(Color.black.opacity(0.95))
            } else {
                Text("Missing image")
            }
        }
        .ignoresSafeArea()
        .navigationTitle(item.image?.caption ?? "Image")
    }
}
