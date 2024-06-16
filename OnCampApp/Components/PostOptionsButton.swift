//
//  PostOptionsButton.swift
//  OnCampApp
//
//  Created by Michael Washington on 6/5/24.
//

import SwiftUI

import SwiftUI

struct PostOptionsButton: View {
    @Binding var deleteaction: Bool

    var body: some View {
        ZStack {
            Button {
                deleteaction.toggle()
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(Color("LTBL"))
            }

            if deleteaction {
                VStack(spacing: 8) {
                    ForEach(PostData.UserPostEditOptions.allCases, id: \.self) { option in
                        Divider()
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        Button(action: {
                            withAnimation {
                                deleteaction.toggle()
                            }
                        }) {
                            Text(option.rawValue)
                                .foregroundColor(.red)
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 5)
                .zIndex(1) // Ensure the menu is on top
            }
        }
    }
}

//#Preview {
//    PostOptionsButton()
//}
