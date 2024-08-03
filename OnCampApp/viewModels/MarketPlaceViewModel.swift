import Foundation

@MainActor
class MarketplaceViewModel: ObservableObject {
    @Published private var vendors: [Vendor] = []
    private var vendorData = VendorData()

    init() {
        Task {
            await fetchVendors()
        }
    }

    private func fetchVendors() async {
        do {
            let vendorIds = try await vendorData.fetchVendorIds()
            var fetchedVendors: [Vendor] = []
            
            for vendorId in vendorIds {
                let vendor = try await vendorData.getVendorData(vendorID: vendorId)
                fetchedVendors.append(vendor)
            }

            self.vendors = fetchedVendors
        } catch {
            print("Error fetching vendors: \(error.localizedDescription)")
        }
    }

    func getAllCategories() -> [String] {
        Array(Set(vendors.flatMap { $0.category })).sorted()
    }

    func getVendors(for category: String) -> [Vendor] {
        if category == "All" {
            return vendors
        } else {
            return vendors.filter { $0.category.contains(category) }
        }
    }

    func getFeaturedVendors() -> [Vendor] {
        vendors.filter { $0.featured }
    }
}
