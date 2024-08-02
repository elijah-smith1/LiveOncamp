import SwiftUI

struct EventPreview: View {
    let event: Event
    
    var body: some View {
        NavigationStack {
            NavigationLink(destination: DetailedEvent(event: event)) {
                GroupBox {
                    GroupBox {
                        VStack {
                            EventImageCarousel(imageUrls: event.imageUrls ?? [""])
                                .frame(height: 105)
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
                    .frame(height: 280)  // Standardize height
                }
                .groupBoxStyle(.lightBlue)
                .frame(height: 300)
            }
        }
        .padding()
        
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

//#Preview{
//    EventPreview(event: Event)
//    
//}
