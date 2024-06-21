//
//  Select Interests.swift
//  OnCampApp
//
//  Created by Michael Washington on 10/9/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct Interests: View {
    var uid: String
    @Binding var path: NavigationPath
    @StateObject var userData = UserData()
    @State private var selectedInterests: Set<String> = []
    @State private var navigate = false // This controls the navigation
    @State private var titleOffset: CGFloat = -300 // Start title offscreen
    @State private var titleScale: CGFloat = 0.5 // Start small for bounce-in effect

    let columns = [
        GridItem(.adaptive(minimum: 100), spacing: 10)
    ]

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                HStack {
                    Text("Select")
                        .foregroundColor(Color.blue)
                        .padding(.trailing, -5.0)
                        .offset(x: titleOffset)
                        .scaleEffect(titleScale)
                        .animation(.interpolatingSpring(stiffness: 50, damping: 5).delay(0.1), value: titleOffset)
                    Text("Interests!")
                        .offset(x: titleOffset)
                        .scaleEffect(titleScale)
                        .animation(.interpolatingSpring(stiffness: 50, damping: 5).delay(0.1), value: titleOffset)
                    Spacer()
                    Button(action: {
                        path.removeLast()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.blue)
                    }
                }
                .padding(.leading, 4.0)
                .font(.largeTitle)
                .fontWeight(.black)
                .multilineTextAlignment(.center)

                Spacer()

                ProgressView(value: Double(selectedInterests.count), total: 5)
                    .padding(.horizontal)
                    .progressViewStyle(LinearProgressViewStyle(tint: selectedInterests.count >= 5 ? .green : .blue))

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(userData.interests, id: \.self) { interest in
                            InterestButton(interest: interest, isSelected: selectedInterests.contains(interest)) {
                                if selectedInterests.contains(interest) {
                                    selectedInterests.remove(interest)
                                } else if selectedInterests.count < 5 {
                                    selectedInterests.insert(interest)
                                }
                            }
                            .animation(.easeInOut(duration: 0.3), value: selectedInterests.contains(interest))
                        }
                    }
                    .padding()
                }

                Button(action: {
                    let documentRef = Userdb.document(uid)
                    documentRef.updateData([
                        "interests": Array(selectedInterests)
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                            self.navigate = true
                        }
                    }
                }) {
                    Text("Continue")
                        .font(.headline)
                        .padding()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .background(selectedInterests.count >= 5 ? Color.blue : Color.gray)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .disabled(selectedInterests.count < 5)
                .animation(.easeInOut(duration: 0.3), value: selectedInterests.isEmpty)
                .navigationDestination(isPresented: $navigate) {
                    tabBar(path: $path)
                }
            }
            .onAppear {
                titleOffset = 0
                titleScale = 1.0
            }
        }
    }
}

struct InterestButton: View {
    let interest: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(interest)
                .padding()
                .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(isSelected ? .white : .black)
                .cornerRadius(10)
        }
    }
}

struct Interests_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Interests(uid: "ZFFYfUMeAwOs3htOW4bANa05RN02", path: .constant(NavigationPath()))
                .preferredColorScheme(.light)
            Interests(uid: "ZFFYfUMeAwOs3htOW4bANa05RN02", path: .constant(NavigationPath()))
                .preferredColorScheme(.dark)
        }
    }
}
