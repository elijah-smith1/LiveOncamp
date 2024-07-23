import SwiftUI

struct Social: View {
    @State private var selectedCategory: String = "All"
    @State private var showingSearchView = false
    @State private var messageNotificationCount = 2
    @State private var notificationCount = 5
    @State private var titleOffset: CGFloat = -300 // Start title offscreen
    @State private var titleScale: CGFloat = 0.5 // Start small for bounce-in effect
    @State private var eventsOffset: CGFloat = -300
    @State private var pickerOffset: CGFloat = -300

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    HStack(spacing: 0) {
                        Text("Social")
                            .foregroundColor(Color("LTBL"))
                            .font(.title)
                            .italic()
                            .bold()
                            .offset(x: titleOffset)
                            .scaleEffect(titleScale)
                            .animation(.interpolatingSpring(stiffness: 50, damping: 5).delay(0.1), value: titleOffset)
                        
                        Text("Hub!")
                            .foregroundColor(.blue)
                            .font(.title)
                            .italic()
                            .bold()
                            .offset(x: titleOffset)
                            .scaleEffect(titleScale)
                            .animation(.interpolatingSpring(stiffness: 50, damping: 5).delay(0.1), value: titleOffset)
                    }
                    Spacer()
                    HStack(spacing: 16) {
                        NavigationLink(destination: Messages()) {
                            BadgeView(iconName: "message", count: messageNotificationCount)
                                .font(.system(size: 24))
                        }
                        NavigationLink(destination: NotificationsView()) {
                            BadgeView(iconName: "bell", count: notificationCount)
                                .font(.system(size: 24))
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .onAppear {
                    titleOffset = 0
                    titleScale = 1.0
                    eventsOffset = 0
                    pickerOffset = 0
                }

                customSearchBar

                ScrollView {
                    VStack {
                        featuredEventsTitle
                        featuredEventsGrid
                        categoryScroller
                        contentSwitcherView
                    }
                    .padding(.bottom, 20)
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
            .cornerRadius(20)
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
            .offset(y: eventsOffset)
            .animation(.interpolatingSpring(stiffness: 50, damping: 5).delay(0.2), value: eventsOffset)
    }

    var featuredEventsGrid: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: [GridItem(.fixed(160))], spacing: 10) {
                ForEach(0..<6) { _ in // Adjust the range based on your data
                    Rectangle()
                        .frame(width: 120, height: 160)
                        .overlay(Rectangle().stroke(Color.cyan, lineWidth: 2))
                        .padding(.horizontal, 5)
                }
            }
            .padding(.horizontal)
            .offset(y: eventsOffset)
            .animation(.interpolatingSpring(stiffness: 50, damping: 5).delay(0.3), value: eventsOffset)
        }
    }

    var categoryScroller: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(socialcategoryList, id: \.id) { category in
                    Button(action: {
                        selectedCategory = category.title
                    }) {
                        CategoryItem(category: category, isSelected: selectedCategory == category.title)
                    }
                }
            }
            .padding()
            .offset(y: pickerOffset)
            .animation(.interpolatingSpring(stiffness: 50, damping: 5).delay(0.4), value: pickerOffset)
        }
    }

    var contentSwitcherView: some View {
        Group {
            switch selectedCategory {
            case "All":
                AllEvents()
            case "Tournaments":
                TournamentEvents()
            case "School":
                SchoolEvents()
            case "Parties":
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

#Preview {
    Social()
}
