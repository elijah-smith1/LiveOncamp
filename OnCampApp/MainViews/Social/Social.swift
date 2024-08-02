import SwiftUI

struct Social: View {
    @StateObject var viewModel = eventViewModel()
    @State private var selectedCategory: String = "All"
    @State private var showingSearchView = false
    @State private var messageNotificationCount = 2
    @State private var notificationCount = 5
    @State private var titleOffset: CGFloat = -300
    @State private var titleScale: CGFloat = 0.5
    @State private var eventsOffset: CGFloat = -300
    @State private var pickerOffset: CGFloat = -300
    
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack(spacing: 0) {
                    headerView
                    customSearchBar
                    VStack(spacing: 0) {
                        featuredEventsSection
                        categoryScroller
                        eventSections
                    }
                    
                    .ignoresSafeArea(edges: .bottom)
                }
            }
        }
    }
    
    var headerView: some View {
        HStack {
            HStack(spacing: 0) {
                Text("Social")
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
            .offset(x: titleOffset)
            .scaleEffect(titleScale)
            .animation(.interpolatingSpring(stiffness: 50, damping: 5).delay(0.1), value: titleOffset)
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
    
    var featuredEventsSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Featured Events")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(viewModel.events.prefix(3), id: \.id) { event in
                        EventPreview(event: event)
                            .frame(width: 300, height: 300)
                    }
                }
            }
        }
        .padding(.vertical)
        .offset(y: eventsOffset)
        .animation(.interpolatingSpring(stiffness: 50, damping: 5).delay(0.2), value: eventsOffset)
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
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
        .offset(y: pickerOffset)
        .animation(.interpolatingSpring(stiffness: 50, damping: 5).delay(0.3), value: pickerOffset)
    }
    
    var eventSections: some View {
        NavigationStack{
            if selectedCategory == "All" || selectedCategory == "Tournaments" {
                eventSection(title: "Tournaments", events: filteredEvents(for: "Tournament"))
            }
            if selectedCategory == "All" || selectedCategory == "School" {
                eventSection(title: "School Events", events: filteredEvents(for: "School"))
            }
            if selectedCategory == "All" || selectedCategory == "Parties" {
                eventSection(title: "Parties", events: filteredEvents(for: "Party"))
            }
        }
            .padding(.top)
    }
    
    func eventSection(title: String, events: [Event]) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(events, id: \.id) { event in
                        EventPreview(event: event)
                            .frame(width: 300, height: 300)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    func filteredEvents(for category: String) -> [Event] {
        if selectedCategory == "All" {
            return viewModel.events
        } else {
            var filteredEvents: [Event] = []
            for event in viewModel.events {
                if event.category == category {
                    filteredEvents.append(event)
                }
            }
            return filteredEvents
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
