import SwiftUI
import Kingfisher

struct VendorDetail: View {
    @State var products: [Products] = []
    let vendor: Vendor
    @StateObject var viewmodel = VendorViewModel()
    @State private var deliveryOption: DeliveryOption = .pickup
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @State private var showVendorInfo = false // State to control the popover visibility
    
    enum DeliveryOption: String, CaseIterable {
        case pickup = "Pickup"
        case delivery = "Delivery"
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ScrollView {
                VStack(spacing: 0) {
                    // Header Image
                    KFImage(URL(string: vendor.headerImage))
                        .resizable()
                        .scaledToFill()
                        .frame(height: 180)
                        .clipped()
                    
                    // Title, Rating, Profile Image, and Info Button
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            // Profile Image
                            KFImage(URL(string: vendor.pfpUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                                .shadow(radius: 3)

                            // Vendor Name
                            Text(vendor.name)
                                .font(.title)
                                .bold()

                            Spacer()
                            
                            // Info Button
                            Button(action: {
                                showVendorInfo.toggle()
                            }) {
                                Image(systemName: "info.circle")
                                    .font(.title)
                                    .foregroundColor(.blue)
                            }
                            .popover(isPresented: $showVendorInfo, arrowEdge: .bottom) {
                                VStack {
                                    Text("Vendor Information")
                                        .font(.headline)
                                        .padding()
                                    
                                    Text(vendor.description)
                                        .padding()
                                }
                                .frame(width: 200, height: 150)
                            }
                        }
                        .padding(.horizontal)
                        
                        HStack {
                            Text(String(format: "%.1f", vendor.rating))
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text("(54)")
                            Text("•")
                                .padding(.horizontal, 5)
                            Text("Morehouse")

                            Spacer()
                        }
                        .font(.subheadline)
                        .padding(.horizontal)

                        // Delivery options
                        deliveryOptionsView
                        
                        // Fee and time information
                        feeInformationView
                        
                        Divider()
                        
                        // Products header
                        HStack {
                            Text("PRODUCTS")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        productGridView
                    }
                    .background(colorScheme == .dark ? Color.black : Color.white)
                    .offset(y: -20)
                }
            }
            .edgesIgnoringSafeArea(.top)
            .onAppear(perform: fetchProducts)
            .navigationBarBackButtonHidden()
            
            // Back button
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                    .padding(20)
            }
            .padding(.leading, 16)
        }
    }
    
    var deliveryOptionsView: some View {
        HStack {
            HStack {
                ForEach(DeliveryOption.allCases, id: \.self) { option in
                    Button(action: {
                        withAnimation {
                            deliveryOption = option
                        }
                    }) {
                        Text(option.rawValue)
                            .foregroundColor(deliveryOption == option ? .white : .blue)
                            .padding(.vertical, 8)
                            .frame(minWidth: 30, maxWidth: 90)
                            .background(deliveryOption == option ? Color.blue : Color.gray.opacity(0.2))
                            .cornerRadius(20)
                    }
                }
                Spacer()
            }
            .fixedSize(horizontal: false, vertical: true)
            .clipShape(Capsule())
            Spacer()
        }
        .padding(.horizontal, 10)
    }
    
    var feeInformationView: some View {
        HStack {
            Spacer()
            Text("$0.49 Delivery Fee")
                .foregroundColor(.white)
            Rectangle()
                .fill(Color.white)
                .frame(width: 1, height: 20)
            Text("35-50 min")
                .foregroundColor(.white)
            Spacer()
        }
        .padding()
        .background(Color.blue)
        .cornerRadius(8)
        .padding(.horizontal)
    }
    
    var productGridView: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
            ForEach(products, id: \.id) { product in
                SmallProductCard(product: product)
            }
        }
        .padding(.horizontal)
    }
    
    func fetchProducts() {
        Task {
            do {
                products = try await viewmodel.fetchAllProducts(forVendor: vendor.id!)
            } catch {
                print("Error fetching products: \(error)")
            }
        }
    }
}
