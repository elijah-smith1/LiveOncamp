import SwiftUI

struct EventPreview: View {
    @ObservedObject var viewModel = eventViewModel()  // Assuming this exists and fetches events
    
    // Define columns for the grid
    private var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        NavigationStack {
            // Using LazyVGrid to create a grid layout
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.events, id: \.id) { event in
                    NavigationLink(destination: DetailedEvent(event: event)) {
                        VStack(spacing: 8) {
                            EventImageCarousel(imageUrls: event.imageUrls ?? [""])
                                .frame(height: 320)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            VStack(alignment: .leading) {
                                Text(event.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("LTBL"))  // Custom color
                                
                                Text("\(event.participants) participants")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Text("Hosted by \(event.host)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            
                            Spacer()
                            
                            HStack {
                                Text("$5-10")
                                    .foregroundColor(.primary)
                            }
                        }
                        .padding(.horizontal)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct EventPreview_Previews: PreviewProvider {
    static var previews: some View {
        EventPreview()
    }
}
