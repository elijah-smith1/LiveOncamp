//
//  Channels.swift
//  OnCampApp
//
//  Created by Michael Washington on 10/17/23.
//

import SwiftUI

struct Channels: View {
    @StateObject var viewmodel = inboxViewModel()
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(viewmodel.channels, id: \.id) { channel in
                    
                    ChannelCell(channel: channel)// Corrected variable name
                }
            }
        }
    }
}

struct Channels_Previews: PreviewProvider {
    static var previews: some View {
        Channels()
    }
}
