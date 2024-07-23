import SwiftUI

struct EventPreview: View {
    @ObservedObject var viewModel = eventViewModel()  // Assuming this exists and fetches events
    
    // Define columns for the grid
    private var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.events, id: \.id) { event in
                        NavigationLink(destination: DetailedEvent(event: event)) {
                            GroupBox {
                                GroupBox {
                                    VStack {
                                        EventImageCarousel(imageUrls: event.imageUrls ?? [""])
                                            .frame(height: 120)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                        
                                        VStack{
                                            Text(event.title)
                                                .font(.headline)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                                .multilineTextAlignment(.center)
                                            
                                            Text(formatParticipants(event.participants))
                                                .font(.caption)
                                                .foregroundColor(.white)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            Text("Hosted by \(event.host)")
                                                .font(.caption)
                                                .foregroundColor(.white)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .fixedSize(horizontal: false, vertical: true)  // Ensure proper wrapping
                                            
                                            HStack {
                                                Text("$5-10")
                                                    .foregroundColor(.white)
                                            }
                                            .padding(.top, 5.0)
                                        }
                                        .padding(.horizontal)
                                    }
                                    .padding(.vertical)
                                }
                                .groupBoxStyle(.blue)
                                .frame(height: 350)  // Standardize height
                            }
                            .groupBoxStyle(.lightBlue)
                            .frame(height: 380)  
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // Utility function to format participant numbers
    private func formatParticipants(_ count: Int) -> String {
        if count >= 1000 {
            return String(format: "%.1f", Double(count) / 1000) + "k participants"
        } else {
            return "\(count) participants"
        }
    }
}

#Preview{
    EventPreview()
    
}
