//
//  Landing.swift
//  OnCampApp
//
//  Created by Michael Washington on 10/9/23.
//

import SwiftUI

struct Landing: View {
    @State private var overlayOffset: CGFloat = 300 // Start offscreen
    @State private var titleOffset: CGFloat = -300 // Start title offscreen
    @State private var circleScale: CGFloat = 0.5 // Start small for bounce-in effect
    @State private var buttonOffset: CGFloat = -300 // Start buttons offscreen

    var body: some View {
        NavigationStack() {
            ZStack {
                VStack {
                    Spacer()

                    HStack {
                        Text("Welcome ")
                            .font(.largeTitle)
                            .bold()
                            .italic()
                            .offset(x: titleOffset) // Apply offset
                            .scaleEffect(circleScale)
                            .animation(.interpolatingSpring(stiffness: 50, damping: 5).delay(0.1), value: titleOffset) // Bounce-in animation

                        Text("OnCamp!")
                            .font(.largeTitle)
                            .bold()
                            .italic()
                            .foregroundColor(.blue)
                            .offset(x: titleOffset) // Apply offset
                            .scaleEffect(circleScale)
                            .animation(.interpolatingSpring(stiffness: 50, damping: 5).delay(0.1), value: titleOffset) // Bounce-in animation
                    }

                    Spacer()
                    Spacer()

                    ZStack {
                        // Main circle
                        Color.blue
                            .clipShape(Circle()) // Smaller corner radius for smaller rounded rectangle
                            .scaledToFill()
                            .ignoresSafeArea()
                            .offset(y: overlayOffset)
                            .scaleEffect(circleScale)
                            .animation(.interpolatingSpring(stiffness: 50, damping: 5).delay(0.2), value: overlayOffset) // Bounce-in animation

                        // Top left circle
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 300, height: 300)
                            .offset(x: -150, y: -150)
                            .scaleEffect(circleScale)
                            .animation(.interpolatingSpring(stiffness: 50, damping: 5).delay(0.3), value: overlayOffset) // Bounce-in animation

                        // Top right circle
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 300, height: 300)
                            .offset(x: 150, y: -150)
                            .scaleEffect(circleScale)
                            .animation(.interpolatingSpring(stiffness: 50, damping: 5).delay(0.3), value: overlayOffset) // Bounce-in animation

                        VStack(spacing: 20) {
                            Spacer()

                            NavigationLink(destination: SignUp()) {
                                HStack {
                                    Image(systemName: "person.badge.plus")
                                    Text("Sign Up For OnCamp")
                                }
                                .foregroundColor(Color("LTBL"))
                                .padding()
                                .background(Color("LTBLALT"))
                                .cornerRadius(10)
                                .offset(y: buttonOffset) // Apply offset
                                .animation(.easeOut(duration: 1).delay(0.4), value: buttonOffset) // Slide-in animation
                            }

                            NavigationLink(destination: SignIn()) {
                                HStack {
                                    Image(systemName: "applelogo")
                                    Text("Sign In to An Existing Account")
                                }
                                .foregroundColor(Color("LTBLALT"))
                                .padding()
                                .background(Color("LTBL"))
                                .cornerRadius(10)
                                .offset(y: buttonOffset) // Apply offset
                                .animation(.easeOut(duration: 1).delay(0.5), value: buttonOffset) // Slide-in animation
                            }

                            NavigationLink(destination: VendorSignUp()) {
                                HStack {
                                    Image(systemName: "storefront")
                                    Text("Register to Become a Vendor")
                                }
                                .foregroundColor(Color("LTBLALT"))
                                .padding()
                                .background(.green)
                                .cornerRadius(10)
                                .padding(.bottom, 40.0)
                                .offset(y: buttonOffset) // Apply offset
                                .animation(.easeOut(duration: 1).delay(0.6), value: buttonOffset) // Slide-in animation
                            }

                            Spacer()
                            Divider()
                                .foregroundStyle(Color("LTBLALT")) // Set divider color to white
                        }
                        .padding(.bottom, 10.0) // Adjust padding to position buttons higher
                    }
                    .frame(width: 500, height: 250) // Adjust frame size
                }
            }
            .onAppear {
                overlayOffset = 0 // Animate overlay to original position
                titleOffset = 0 // Animate title to original position
                circleScale = 1.0 // Animate circles to full size
                buttonOffset = 0 // Animate buttons to original position
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    Landing()
}
