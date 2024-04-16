import SwiftUI

struct Marketplace: View {
    @State var selectedCategory = "All"
    @State private var searchText = ""
    @StateObject var viewModel = MarketplaceViewModel()
    let user: User?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    HStack {
                        Text("Vendor")
                            .foregroundColor(Color("LTBL")) // Changing the color to black
                            .font(.title)
                            .padding(.leading, 20)

                        Text("Hub")
                            .foregroundColor(.blue) // Keeping this part blue
                            .font(.title)
                            .padding(.leading, -10)

                        Spacer() // This will push everything to the sides

                        Button(action: {
                            // Action for receipt
                        }) {
                            Image(systemName: "doc.plaintext")
                                .font(.system(size: 24))
                                .foregroundColor(.blue)
                        }
                        .padding(.trailing, 20)
                    }


                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.blue)

                        TextField("Search for vendors...", text: $searchText)
                            .padding(8)

                        NavigationLink(destination: SideMenu(user: user)) {
                            Image(systemName: "line.3.horizontal")
                                .font(.system(size: 20))
                        }
                    }
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.blue, lineWidth: 2)
                    )
                    .padding(.horizontal)

                    Divider()
                    
                    Spacer()

                    // Categories Scroller
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(categoryList, id: \.id) { category in
                                Button(action: {
                                    selectedCategory = category.title
                                }) {
                                    CategoryItem(category: category, isSelected: selectedCategory == category.title)
                                }
                            }
                        }
                        .padding()
                    }

                    // Dynamically create VendorSection views based on categories
                    ForEach(viewModel.vendorsByCategory.keys.sorted(), id: \.self) { category in
                        VendorSection(title: category, vendors: viewModel.vendorsByCategory[category] ?? [])
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct VendorSection: View {
    var title: String
    var vendors: [Vendor]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 20) {
                    ForEach(vendors, id: \.name) { vendor in
                        VendorPreview(vendor: vendor)
                    }
                }
                .frame(height: 250) // Ensure this height accommodates the size of the VendorPreview cards
                .padding(.horizontal)
            }
            
            Divider()
        }
    }
}


struct CategoryItem: View {
    @Environment(\.colorScheme) var colorScheme // Access the color scheme from the environment
    var category: CategoryModel
    var isSelected: Bool
    
    var backgroundColor: Color {
        isSelected ? .blue : (colorScheme == .dark ? .blue : .gray.opacity(0.1))
    }
    
    var foregroundColor: Color {
        isSelected ? .white : (colorScheme == .dark ? Color("LTBLALT") : .black)
    }
    
    var body: some View {
        HStack {
            if category.title != "All" {
                Image(systemName: category.icon)
                    .foregroundColor(isSelected ? .white : (colorScheme == .dark ? Color("LTBLALT") : .blue))
            }
            Text(category.title)
                .fontWeight(isSelected ? .bold : .regular)
                .foregroundColor(foregroundColor)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 20)
        .background(backgroundColor)
        .clipShape(Capsule())
    }
}


//struct Marketplace_Previews: PreviewProvider {
//    static var previews: some View {
//        Marketplace()
//    }
//}

// Assuming Vendor, VendorData, and CategoryModel structs are defined elsewhere
