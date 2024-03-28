//
//  CMPreviewBox.swift
//  OnCampApp
//
//  Created by Michael Washington on 10/17/23.
//

import SwiftUI

//struct CMPreviewBox: View {
//    @StateObject var viewmodel = chatPreviewsViewModel()
//    var body: some View {
//        
//        NavigationStack() {
//            VStack {
//                ZStack {
//                    Rectangle() // Smaller rectangle on top
//                        .fill(Color("OnCampSky")) // Adjust color as needed
//                        .frame(width: 400, height: 210)
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                    
//                    Rectangle() // Smaller rectangle on top
//                        .fill(Color("LTBLALT")) // Adjust color as needed
//                        .frame(width: 355, height: 190)
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                    
//                    VStack{
//                        
//                        
//                       
//                        
//                        
//                        ForEach(viewmodel.recentMessages, id: \.id) { message in
//                            
//                            CMCells(message: message) // Corrected variable name
//                        }
//                        NavigationLink(destination: Messages()) {
//                            Text("View All")
//                            
//                            
//                        }
//                        
//                    }
//                    
//                }
//            }
//        }
//    }
//}

//struct CMPreviewBox_Previews: PreviewProvider {
//    static var previews: some View {
//        CMPreviewBox()
//    }
//}
