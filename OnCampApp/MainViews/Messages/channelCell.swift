//
//  channelCell.swift
//  OnCampApp
//
//  Created by Elijah and Mike on 2/23/24.
//

import SwiftUI



struct ChannelCell: View {
    
    @StateObject var viewModel = MessageCellViewModel()
    var channel: Channel
    
    var body: some View {
           NavigationStack {
               NavigationLink(destination: ChannelFeed(channel: channel)) {
                   Divider()
                   HStack {
                       // Profile picture placeholder
                       Image(systemName: "person.crop.circle.fill")
                           .resizable()
                           .frame(width: 40, height: 40)
                           .foregroundColor(.blue)
                       
                       // Channel name
                       VStack(alignment: .leading, spacing: 4) {
                           Text("channel.title")
                               .font(.headline)
                           Text(viewModel.content.isEmpty ?? true ? "didn't work" : viewModel.content ?? "didn't work")
                           // Display recent message text and timestamp
                           
//                               Text(recentMessage.content)
//                                   .font(.subheadline)
//                                   .foregroundColor(.gray)
                               
                            
                                   .font(.caption)
                                   .foregroundColor(.secondary)
                           }
                       }
                       Spacer()
                   }
                   .padding()
               }.onAppear{
                   viewModel.fetchRecentGroupMessage(channelId: channel.id!) 
               }
    }
   }
