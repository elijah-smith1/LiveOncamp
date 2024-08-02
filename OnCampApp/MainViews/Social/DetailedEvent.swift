//
//  DetailedEvent.swift
//  OnCampApp
//
//  Created by Michael Washington on 10/30/23.
//

import SwiftUI
import MapKit

struct DetailedEvent: View {
    var event: Event
    @State private var selectedAddons: Set<String> = []
    @State private var totalPrice: Double = 20.00 // Base price
    @State private var showTicketConfirmation = false
    @Environment(\.presentationMode) var presentationMode
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var isRegionSet = false
    @State private var eventLocation: EventLocation?
    
    let addons = [
        "Skip Line": 10.00,
        "Drink Package": 25.00,
        "VIP Section": 50.00
    ]
    
    var body: some View {
        ZStack(alignment: .top) {
            Color("LTBLALT").edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 0) {
                    imageCarouselWithBackButton
                    
                    VStack(alignment: .leading, spacing: 20) {
                        eventTitleSection
                        eventInfoSection
                        Divider().background(Color("LTBL"))
                        hostInfoSection
                        Divider().background(Color("LTBL"))
                        featuresSection
                        Divider().background(Color("LTBL"))
                        addonPackagesSection
                        Divider().background(Color("LTBL"))
                        mapSection
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 100) // Extra padding for the overlay
            }
            .edgesIgnoringSafeArea(.top)
            
            VStack {
                Spacer()
                purchaseOverlay
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            setRegionFromAddress(event.location)
        }
        .sheet(isPresented: $showTicketConfirmation) {
            TicketConfirmation(event: event, addons: selectedAddons, totalPrice: totalPrice)
        }
    }
    
    var imageCarouselWithBackButton: some View {
        ZStack(alignment: .topLeading) {
            EventImageCarousel(imageUrls: event.imageUrls ?? [""])
                .frame(height: UIScreen.main.bounds.height * 0.4)
                .edgesIgnoringSafeArea(.all)
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .font(.title2)
                    .padding(20)
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
            }
            .padding(.top, 60)
            .padding(.leading, 20)
        }
    }
    
    var eventTitleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(event.title)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color("LTBL"))
            
            HStack {
                Label("2D 6H 3M", systemImage: "clock")
                Spacer()
                Label("\(event.participants)", systemImage: "person.3")
            }
            .font(.subheadline)
            .foregroundColor(Color("LTBL").opacity(0.7))
            
            Text(event.location)
                .font(.subheadline)
                .foregroundColor(Color("LTBL").opacity(0.7))
        }
    }
    
    var eventInfoSection: some View {
        HStack {
            InfoCard(title: "Date", value: "Sep 15")
            InfoCard(title: "Time", value: "8:00 PM")
            InfoCard(title: "Base Price", value: "$20.00")
        }
    }
    
    var hostInfoSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Hosted by")
                    .font(.subheadline)
                    .foregroundColor(Color("LTBL").opacity(0.7))
                Text(event.host)
                    .font(.headline)
                    .foregroundColor(Color("LTBL"))
                Label("Verified Event", systemImage: "checkmark.seal.fill")
                    .font(.caption)
                    .foregroundColor(.green)
            }
            
            Spacer()
            
            CircularProfilePictureView()
                .frame(width: 64, height: 64)
        }
        .padding()
        .background(Color("LTBL").opacity(0.1))
        .cornerRadius(12)
    }
    
    var featuresSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Event Features")
                .font(.headline)
                .foregroundColor(Color("LTBL"))
            
            ForEach(0..<2) { feature in
                HStack(spacing: 12) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    
                    VStack(alignment: .leading) {
                        Text("Feature \(feature + 1)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("LTBL"))
                        
                        Text("Description of feature \(feature + 1)")
                            .font(.caption)
                            .foregroundColor(Color("LTBL").opacity(0.7))
                    }
                }
            }
        }
    }
    
    var addonPackagesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Add-on Packages")
                .font(.headline)
                .foregroundColor(Color("LTBL"))
            
            ForEach(addons.sorted(by: { $0.key < $1.key }), id: \.key) { addon, price in
                HStack {
                    Button(action: {
                        if selectedAddons.contains(addon) {
                            selectedAddons.remove(addon)
                            totalPrice -= price
                        } else {
                            selectedAddons.insert(addon)
                            totalPrice += price
                        }
                    }) {
                        HStack {
                            Image(systemName: selectedAddons.contains(addon) ? "checkmark.square.fill" : "square")
                                .foregroundColor(Color("LTBL"))
                            Text(addon)
                                .foregroundColor(Color("LTBL"))
                            Spacer()
                            Text("$\(String(format: "%.2f", price))")
                                .foregroundColor(Color("LTBL"))
                        }
                    }
                }
                .padding()
                .background(Color("LTBL").opacity(0.1))
                .cornerRadius(12)
            }
        }
    }
    
    var mapSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Location")
                .font(.headline)
                .foregroundColor(Color("LTBL"))
            
            Map(coordinateRegion: $region, annotationItems: eventLocation != nil ? [eventLocation!] : []) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.red)
                        .font(.title)
                        .onTapGesture {
                            openInAppleMaps(location: location.coordinate)
                        }
                }
            }
            .frame(height: 200)
            .cornerRadius(12)
            .onAppear {
                if !isRegionSet {
                    setRegionFromAddress(event.location)
                }
            }
        }
    }
    
    var purchaseOverlay: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Total Price")
                    .font(.caption)
                    .foregroundColor(Color("LTBL").opacity(0.7))
                Text("$\(String(format: "%.2f", totalPrice))")
                    .font(.headline)
                    .foregroundColor(Color("LTBL"))
            }
            Spacer()
            Button(action: {
                showTicketConfirmation = true
            }) {
                Text("Buy Ticket")
                    .fontWeight(.semibold)
                    .foregroundColor(Color("LTBLALT"))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color("LTBL"))
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color("LTBLALT").opacity(0.9))
        .cornerRadius(12)
        .shadow(color: Color("LTBL").opacity(0.1), radius: 5, y: -5)
        .padding(.horizontal)
    }
    
    // Function to set the region using the geocoded address
    private func setRegionFromAddress(_ address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                return
            }
            guard let placemark = placemarks?.first,
                  let location = placemark.location else {
                print("No location found")
                return
            }
            let coordinate = location.coordinate
            eventLocation = EventLocation(id: UUID(), coordinate: coordinate)
            region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
            isRegionSet = true
        }
    }
    
    private func openInAppleMaps(location: CLLocationCoordinate2D) {
        let placemark = MKPlacemark(coordinate: location)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = event.title
        mapItem.openInMaps()
    }
}

// Custom struct for event location
struct EventLocation: Identifiable {
    let id: UUID
    let coordinate: CLLocationCoordinate2D
}


struct InfoCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(Color("LTBL").opacity(0.7))
            Text(value)
                .font(.headline)
                .foregroundColor(Color("LTBL"))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color("LTBL").opacity(0.1))
        .cornerRadius(12)
    }
}

//struct DetailedEvent_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailedEvent(event: Event(
//            title: "OnCamp Release Party",
//            host: "Best Parties ATL",
//            location: "830 Westview Drive",
//            participants: 520,
//            images: ["Events1", "Events2", "Events3"]
//        ))
//    }
//}


