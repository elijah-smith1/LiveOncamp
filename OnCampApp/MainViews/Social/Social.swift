import SwiftUI

struct Social: View {
    let categories = ["All", "Tournament", "School", "Parties"]
    @State private var selectedCategoryIndex = 0
    @State private var showingSearchView = false
    @State private var messageNotificationCount = 2
    @State private var notificationCount = 5

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                customSearchBar
                ScrollView {
                    VStack {
                        featuredEventsTitle
                        instagramStyleBoxes
                        categoryPicker
                        contentSwitcherView
                    }
                    .padding(.bottom, 20)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack(spacing: 0) {  // Ensures the texts are touching
                        Text("Social")
                            .foregroundColor(Color("LTBL")) // Custom color, ensure this exists in your assets
                            .font(.title)
                        
                        Text("Hub")
                            .foregroundColor(.blue) // Blue color for "Hub"
                            .font(.title)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 20) {
                        NavigationLink(destination: Messages()) {
                            BadgeView(iconName: "message", count: messageNotificationCount)
                        }
                        NavigationLink(destination: NotificationsView()) {
                            BadgeView(iconName: "bell", count: notificationCount)
                        }
                    }
                }
            }
        }
    }

    var customSearchBar: some View {
        Button(action: {
            showingSearchView = true
        }) {
            HStack {
                Image(systemName: "magnifyingglass")
                Text("Search...")
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(8)
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blue, lineWidth: 1)
            )
        }
        .padding(.horizontal)
        .padding(.top, 8)
        .sheet(isPresented: $showingSearchView) {
            Search()
        }
    }

    var featuredEventsTitle: some View {
        Text("Featured Events")
            .font(.callout)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
    }

    var instagramStyleBoxes: some View {
        HStack {
            ForEach(0..<3) { _ in
                Rectangle()
                    .frame(width: 120, height: 160)
                    .overlay(Rectangle().stroke(Color.cyan, lineWidth: 2))
            }
        }
        .padding(.horizontal)
    }

    var categoryPicker: some View {
        Picker("Categories", selection: $selectedCategoryIndex) {
            ForEach(categories.indices, id: \.self) { index in
                Text(categories[index]).tag(index)
            }
        }
        .pickerStyle(.segmented)
        .padding()
    }

    var contentSwitcherView: some View {
        Group {
            switch selectedCategoryIndex {
            case 0:
                AllEvents()
            case 1:
                TournamentEvents()
            case 2:
                SchoolEvents()
            case 3:
                PartyEvents()
            default:
                EmptyView()
            }
        }
    }
}
struct BadgeView: View {
    var iconName: String
    var count: Int

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(systemName: iconName)
            if count > 0 {
                Text("\(count)")
                    .font(.caption2)
                    .foregroundColor(.white)
                    .padding(5)
                    .background(Color.red)
                    .clipShape(Circle())
                    .offset(x: 10, y: -10)
            }
        }
    }
}

struct Social_Previews: PreviewProvider {
    static var previews: some View {
        Social()
    }
}
