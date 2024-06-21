import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import Firebase

struct SignUp: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    @Binding var path: NavigationPath
    @ObservedObject var viewModel = AuthViewModel()
    @State private var showingAlert = false
    @State private var alertMessage: String = ""
    @State private var email: String = ""
    @State private var uid: String = ""
    @State private var password: String = ""
    @State private var confirmedPassword: String = ""
    @State private var signUpSuccessful: Bool = false
    @State private var titleOffset: CGFloat = -300 // Start title offscreen
    @State private var titleScale: CGFloat = 0.5 // Start small for bounce-in effect

    var body: some View {
        if signUpSuccessful {
            CreateAccount(uid: self.uid, path: $path)
        } else {
            content
        }
    }

    var content: some View {
        NavigationStack(path: $path) {
            VStack {
                HStack {
                    Text("Sign")
                        .foregroundColor(Color.blue)
                        .padding(.trailing, -5.0)
                        .offset(x: titleOffset)
                        .scaleEffect(titleScale)
                        .animation(.interpolatingSpring(stiffness: 50, damping: 5).delay(0.1), value: titleOffset)
                    Text("Up!")
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

                Text("Please Create your OnCamp Credentials")

                Spacer()
                Spacer()

                VStack(spacing: 16) {
                    GroupBox {
                        TextField("Email...", text: $email)
                            .padding(6)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .padding(.horizontal, 12)
                    }
                    .frame(width: 370.0)
                    .cornerRadius(30)

                    GroupBox {
                        SecureField("Password...", text: $password)
                            .padding(6)
                            .background(Color(.systemGray6))
                            .padding(.horizontal, 12)
                    }
                    .frame(width: 370.0)
                    .cornerRadius(30)

                    GroupBox {
                        SecureField("Confirm Password...", text: $confirmedPassword)
                            .padding(6)
                            .background(Color(.systemGray6))
                            .padding(.horizontal, 12)
                    }
                    .frame(width: 370.0)
                    .cornerRadius(30)
                }

                Spacer()

                VStack(spacing: 10) {
                    Button(action: {
                        // Action for Google sign up
                    }) {
                        HStack {
                            Image(systemName: "globe")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("Sign Up with Google")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(width: 352, height: 44)
                        .background(Color.red)
                        .cornerRadius(8)
                    }

                    Button(action: {
                        // Action for Apple sign up
                    }) {
                        HStack {
                            Image(systemName: "applelogo")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("Sign Up with Apple")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(width: 352, height: 44)
                        .background(Color.black)
                        .cornerRadius(8)
                    }
                }

                Button(action: {
                    if !isEmailValid(email) {
                        self.alertMessage = "Please enter a valid email address."
                        self.showingAlert = true
                    } else if password.count < 8 {
                        self.alertMessage = "Password must be at least 8 characters long."
                        self.showingAlert = true
                    } else if password != confirmedPassword {
                        self.alertMessage = "Passwords do not match."
                        self.showingAlert = true
                    } else {
                        signUp()
                    }
                }) {
                    Text("Sign Up")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 352, height: 44)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("Got it!")))
                }

                Spacer()

                Divider()

                NavigationLink(destination: SignIn(path: $path)) {
                    HStack {
                        Text("Already have an account?")
                        Text("Sign In")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(Color("LTBL"))
                    .font(.footnote)
                }
                .padding(.vertical, 16)
                .onAppear {
                    Auth.auth().addStateDidChangeListener { auth, user in
                        if user != nil {
                            guard let currentUser = Auth.auth().currentUser else {
                                print("error getting current user")
                                return
                            }
                            self.uid = currentUser.uid
                            signUpSuccessful.toggle()
                            print("uid is \(self.uid)")
                        }
                    }
                }
            }
        }
        .ignoresSafeArea(.keyboard)
        .navigationBarBackButtonHidden()
        .onAppear {
            titleOffset = 0 // Animate title to original position
            titleScale = 1.0 // Animate title to full size
        }
    }

    private func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.alertMessage = error.localizedDescription
                self.showingAlert = true
                print("Signup error: \(error.localizedDescription)")
            } else {
                guard let currentUser = Auth.auth().currentUser else {
                    print("Error getting current user")
                    return
                }
                self.uid = currentUser.uid
                print("User UID: \(self.uid)")
            }
        }
    }
}

private func isEmailValid(_ email: String) -> Bool {
    let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
    return emailPredicate.evaluate(with: email)
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SignUp(path: .constant(NavigationPath()))
                .preferredColorScheme(.light)
            SignUp(path: .constant(NavigationPath()))
                .preferredColorScheme(.dark)
        }
    }
}
