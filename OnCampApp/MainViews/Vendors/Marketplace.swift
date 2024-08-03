import SwiftUI

struct Marketplace: View {
    @State private var selectedCategory = "All"
    @State private var searchText = ""
    @StateObject var viewModel = MarketplaceViewModel()
    let user: User?
    
    @State private var titleOffset: CGFloat = -300
    @State private var titleScale: CGFloat = 0.5
    @State private var featuredOffset: CGFloat = -300
    @State private var categoriesOffset: CGFloat = -300
    @State private var showingSearchView = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    header
                    customSearchBar
                    featuredVendors
                    categoryScroller
                    vendorSections
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0)) {
                titleOffset = 0
                titleScale = 1.0
                featuredOffset = 0
                categoriesOffset = 0
            }
        }
    }
    
    var header: some View {
        NavigationStack{
            HStack {
                HStack(spacing: 0) {
                    Text("Vendor")
                        .foregroundColor(Color("LTBL"))
                        .font(.title)
                        .italic()
                        .bold()
                    Text("Hub!")
                        .foregroundColor(.blue)
                        .font(.title)
                        .italic()
                        .bold()
                }
                Spacer()
                Spacer()
                        NavigationLink(destination: ActiveOAE()) {
                            Image(systemName: "doc.plaintext")
                                .font(.system(size: 24))
                                .foregroundColor(.blue)
                        }
            }
            .offset(x: titleOffset)
            .scaleEffect(titleScale)
            .padding(.horizontal)
        }
    }
    
    var customSearchBar: some View {
        Button(action: {
            showingSearchView = true
        }) {
            HStack {
                Image(systemName: "magnifyingglass")
                Text("Search for vendors...")
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(8)
            .background(Color.white)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.blue, lineWidth: 1)
            )
        }
        .padding(.horizontal)
        .sheet(isPresented: $showingSearchView) {
            Search()
        }
    }
    
    var featuredVendors: some View {
        VStack(alignment: .leading) {
            Text("Featured Vendors")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 15) {
                    ForEach(viewModel.getFeaturedVendors(), id: \.id) { vendor in
                        VendorPreview(vendor: vendor)
                    }
                }
                .padding(.horizontal)
            }
        }
        .offset(y: featuredOffset)
    }
    
    var categoryScroller: some View {
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
        .offset(y: categoriesOffset)
    }
    
    
    var vendorSections: some View {
        VStack(spacing: 20) {
            if selectedCategory == "All" {
                ForEach(viewModel.getAllCategories(), id: \.self) { category in
                    if category != "Featured" {
                        GroupBox {
                            VendorSection(title: category, vendors: viewModel.getVendors(for: category))
                        } label: {
                            Text(category)
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                        .groupBoxStyle(LightBlueGroupBoxStyle())
                    }
                }
            } else {
                GroupBox {
                    VendorSection(title: selectedCategory, vendors: viewModel.getVendors(for: selectedCategory))
                } label: {
                    Text(selectedCategory)
                        .font(.headline)
                        .foregroundColor(.black)
                }
                .groupBoxStyle(LightBlueGroupBoxStyle())
            }
        }
        .padding(.horizontal)
    }
}

struct VendorSection: View {
    var title: String
    var vendors: [Vendor]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 15) {
                ForEach(vendors, id: \.id) { vendor in
                    VendorPreview(vendor: vendor)
                }
            }
        }
    }
}

struct CategoryItem: View {
    @Environment(\.colorScheme) var colorScheme
    var category: CategoryModel
    var isSelected: Bool
    
    var backgroundColor: Color {
        isSelected ? .blue : (colorScheme == .dark ? .blue.opacity(0.3) : .gray.opacity(0.1))
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
        .padding(.horizontal, 16)
        .background(backgroundColor)
        .clipShape(Capsule())
    }
}
