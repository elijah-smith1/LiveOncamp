//
//  Search.swift
//  letsgetrich
//
//  Created by Michael Washington on 9/13/23.
//

import SwiftUI

struct Search: View {
    @StateObject var viewmodel = searchViewModel()
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            VStack {
                SearchBar(searchText: $searchText)
                
                List {
                    ForEach(filteredUsers, id: \.username) { user in
                        UserCell(user: user)
                            
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Search")
        }
    }

    var filteredUsers: [User] {
        if searchText.isEmpty {
            return viewmodel.users
        } else {
            return viewmodel.users.filter { $0.username.localizedCaseInsensitiveContains(searchText) }
        }
    }
}

struct Search_Previews: PreviewProvider {
    static var previews: some View {
        Search()
    }
}

struct SearchBar: View {
    @Binding var searchText: String

    var body: some View {
        HStack {
            TextField("Search Users", text: $searchText)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
        }
    }
}
