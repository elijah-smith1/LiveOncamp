import SwiftUI
import Kingfisher

struct ExpandableImageView: View {
    let imageUrl: URL
    @State private var isExpanded = false
    
    var body: some View {
        ZStack {
            if isExpanded {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    KFImage(imageUrl)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.white)
                        .onTapGesture {
                            withAnimation {
                                isExpanded.toggle()
                            }
                        }
                    Spacer()
                }
            } else {
                KFImage(imageUrl)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 300, height: 200)
                    .clipped()
                    .cornerRadius(8)
                    .padding(.top, 5)
                    .onTapGesture {
                        withAnimation {
                            isExpanded.toggle()
                        }
                    }
            }
        }
    }
}
