//
//  DetailedEvent.swift
//  OnCampApp
//
//  Created by Michael Washington on 10/30/23.
//

import SwiftUI

struct DetailedEvent: View {
    var event: Event
    
    var body: some View {
        ScrollView {
            EventImageCarousel(imageUrls: event.imageUrls ?? [""])
                .frame(height: 320)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(event.title)
                    .font(.title)
                    .fontWeight(.semibold)
                
                VStack(alignment: .leading) {
                    HStack(spacing: 2) {
                        Text("2D 6H 3M")  // Consider making this dynamic if you have event timing data
                            .padding(.trailing, 8.0)
                        Image(systemName: "person")
                        Text(" \(event.participants)")
                    }
                    .foregroundColor(Color("LTBL"))
                    
                    Text(event.location)
                }
                .font(.caption)
            }
            .padding(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            HStack{
                VStack{
                    Text("This Event is being hosted by \(event.host)")
                        .font(.headline)
                        .frame(width:250, alignment: .leading)
                    HStack(spacing: 2) {
                        Text("Verified Event")
                        
                        Image(systemName: "checkmark")
                            .foregroundColor(.green)
                        
                    }
                    .frame(width:250, alignment: .leading)
                    .font(.caption)
                }
                .frame(width:300)
                
                Spacer()
                
                CircularProfilePictureView()
                    .frame(width: 64, height: 64)
            }
            .padding()
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16) {
                ForEach(0 ..< 2) { feature in
                    HStack(spacing: 12) {
                        Image(systemName: "wineglass")
                        
                        VStack(alignment: .leading) {
                            Text("BYOB")
                                .font(.footnote)
                                .fontWeight(.semibold)
                            
                            Text("Aye man say man dont be on that freeloading shit bring your own drinks")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                        Spacer()
                    }
                }
            }
            .padding()
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Ticket Packages")
                    .font(.headline)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(1 ..< 5) { ticket in
                            VStack {
                                Image(systemName: "ticket")
                                Text("Ticket \(ticket)")
                            }
                            .frame(width: 132, height:100)
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(lineWidth: 1)
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                }
            }
            .padding()
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16) {
                
                Text("What'll be there")
                    .font(.headline)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(0 ..< 5) { feature in
                            HStack {
                                Image(systemName: "leaf")
                                Text("Feature \(feature)")
                            }
                            .frame(width: 132, height:100)
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(lineWidth: 1)
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                }
            }.padding()
        }
    }
}


//struct DetailedEvent_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailedEvent(event: Event(
//            title: "OnCamp Release Party",
//            host: "Best Parties ATL",
//            location: "830 Westview Drive",
//            participants: 520,
//            images: ["Events1", "Events2", "Events3"]
//        ))
//    }
//}


