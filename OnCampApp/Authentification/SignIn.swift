//
//  SignIn.swift
//  OnCampApp
//
//  Created by Michael Washington on 10/9/23.
//

import SwiftUI
import FirebaseAuth

struct SignIn: View {
    @ObservedObject var viewModel = AuthViewModel()
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    @State private var loginSuccessful: Bool = false

    var body: some View {
        if loginSuccessful {
            tabBar()
        } else {
            content
        }
    }
    
    var content: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Sign")
                        .foregroundColor(Color.blue)
                        .padding(.trailing, -5.0)
                    Text("In!")
                    Spacer()
                    Button(action: {
                        dismiss()
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
                
                Text("Welcome Back to OnCamp!")
                
                Spacer()
                
                VStack(spacing: 16) {
                    GroupBox {
                        TextField("Enter Your Email", text: $email)
                            .padding(6)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .padding(.horizontal, 12)
                    }
                    .frame(width: 370.0)
                    .cornerRadius(30)
                    
                    GroupBox {
                        SecureField("Enter Your Password", text: $password)
                            .padding(6)
                            .background(Color(.systemGray6))
                            .padding(.horizontal, 12)
                    }
                    .frame(width: 370.0)
                    .cornerRadius(30)
                }
                
                NavigationLink {
                    forgotPassword()
                } label: {
                    Text("Forgot Password?")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .padding(.top)
                        .padding(.trailing, 28)
                        .foregroundColor(Color("LTBL"))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                Spacer()
                
                Button {
                    login()
                } label: {
                    Text("Login")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 352, height: 44)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("Got it!")))
                }
                
                Spacer()
                
                Divider()
                    .foregroundColor(Color("LTBL"))
                
                NavigationLink {
                    SignUp()
                } label: {
                    HStack {
                        Text("Don't have an account?")
                        Text("Sign Up")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(Color("LTBL"))
                    .font(.footnote)
                }
                .padding(.vertical, 16)
            }
        }
        .ignoresSafeArea(.keyboard)
        .navigationBarBackButtonHidden()
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.alertMessage = error.localizedDescription
                print(self.alertMessage)
                self.showAlert = true
            } else {
                print("sign in successful")
                self.loginSuccessful = true
                
            }
        }
    }
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SignIn()
                .preferredColorScheme(.light)
            SignIn()
                .preferredColorScheme(.dark)
        }
    }
}
