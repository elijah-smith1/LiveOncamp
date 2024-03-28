//
//  UserRepostsView.swift
//  OnCampApp
//
//  Created by Elijah and Mike on 1/31/24.
//

import SwiftUI

struct UserRepostsView: View {
    let viewModel : ProfileViewModel
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(viewModel.userReposts, id: \.id) { post in
                        PostCell(post: post)
                    }
                }
            }
           
        }
    }
}
//#Preview {
//    UserRepostsView()
//}
