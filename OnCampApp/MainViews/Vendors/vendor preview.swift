//
//  vendor preview.swift
//  OnCampApp
//
//  Created by Elijah Smith on 12/28/23.
//

//
//  vendor preview.swift
//  OnCampApp
//
//  Created by Elijah Smith on 12/28/23.
//

import SwiftUI
import Kingfisher

struct VendorPreview: View {
    let vendor: Vendor

    var body: some View {
        NavigationLink(destination: VendorDetail(vendor: vendor)) {
            VStack(alignment: .leading) {
                // Business Image
                KFImage(URL(string: vendor.headerImage))
                    .resizable()
                    .placeholder {
                        Image("placeholder") // Replace with your placeholder image
                            .resizable()
                            .scaledToFit()
                    }
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 300, height: 200) // Adjust the width as needed
                    .clipped()
                    .cornerRadius(8)

                // Business Name and Category
                HStack {
                    Text(vendor.name)
                        .font(.headline)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .frame(width: 220, alignment: .leading) // Width to show approx. 15 characters

                    Spacer()

                    Text(vendor.category)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }

                // Rating, Avg. Price, School in a compact line
                HStack(spacing: 0) {
                    StarRating(vendor: vendor) // Custom view to display star rating
                    Text(" · ") // Dot separator
                    Text(" Price: $5-10") // Average price
                    Text(" · ") // Dot separator
                    Text(" Morehouse") // School
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
            .padding([.horizontal, .bottom], 10) // Reduced padding
            .padding(.top, 5)
        }
    }
}



//struct VendorPreview_Previews: PreviewProvider {
//    static var previews: some View {
//        VendorPreview(vendor: Vendor(description: "Description", schools: ["Morehouse","Spelman","Clark Atlanta"], name: "New Hairstylist", image: "https://source.unsplash.com/random/300x300", category: "Hair", rating: 4.3, featured: false))
//    }
//}
