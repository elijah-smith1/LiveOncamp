import SwiftUI

struct EventImageCarousel: View {
    var imageUrls: [String]
    
    var body: some View {
        TabView {
            ForEach(imageUrls, id: \.self) { imageUrl in
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image.resizable()
                         .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 200) // You can adjust the height as needed
                .cornerRadius(10)
                .padding(.horizontal)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .frame(height: 200) // Ensure the TabView is constrained if AsyncImage is not inherently sized
    }
}

struct EventImageCarousel_Previews: PreviewProvider {
    static var previews: some View {
        EventImageCarousel(imageUrls: [
            "https://www.example.com/image1.jpg",
            "https://www.example.com/image2.jpg",
            "https://www.example.com/image3.jpg"
        ])
    }
}
