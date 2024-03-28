//
//  GCSetup.swift
//  OnCampApp
//
//  Created by Elijah and Mike on 2/27/24.
//

import SwiftUI

struct GCSetup: View {
    @State var selectedUsers: [User]
    @State var senders: [User] = []
    @State var security: String = "public"
    @State var gcTitle: String = ""

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        /*
         list of selected users in a participants field filtered by loggedinUid
         
         ask for who is allowed to send
         */
    }
}

//#Preview {
//    GCSetup()
//}
