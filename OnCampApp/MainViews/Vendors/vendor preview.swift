import SwiftUI
import Kingfisher

struct VendorPreview: View {
    let vendor: Vendor

    var body: some View {
        NavigationLink(destination: VendorDetail(vendor: vendor)) {
            VStack(alignment: .leading, spacing: 8) {
                // Business Image
                KFImage(URL(string: vendor.headerImage))
                    .resizable()
                    .placeholder {
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 100)
                            .foregroundColor(.gray)
                    }
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 150)
                    .clipped()
                    .cornerRadius(12)

                VStack(alignment: .leading, spacing: 4) {
                    // Business Name
                    Text(vendor.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(1)

                    // Category
                    if !vendor.category.isEmpty {
                        Text("Categories: \(vendor.category.joined(separator: ", "))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }

                    // Rating and School
                    HStack {
                        StarRating(vendor: vendor)
                        Text(String(format: "%.1f", vendor.rating))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(vendor.schools.first ?? "")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    // Short Description
                    Text(vendor.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    // Featured Badge
                    if vendor.featured {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text("Featured")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.yellow)
                        }
                        .padding(.top, 4)
                    }
                }
                .padding(12)
            }
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}


struct VendorPreview_Previews: PreviewProvider {
    static var previews: some View {
        VendorPreview(vendor: Vendor(
            id: "1",
            description: "Best coffee on campus",
            schools: ["Morehouse", "Spelman", "Clark Atlanta"],
            name: "Campus Cafe",
            headerImage: "https://example.com/cafe.jpg",
            category: ["Food & Drink"],
            rating: 4.5,
            featured: true,
            pfpUrl: "https://example.com/profile.jpg"
        ))
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
