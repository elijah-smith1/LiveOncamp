import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct CreateAccount: View {
    var uid: String
    
    @ObservedObject var userData = UserData()
    
    @Environment(\.colorScheme) var colorScheme
    @Binding var path: NavigationPath // Add NavigationPath binding
    @State private var showingAlert = false
    @State private var alertMessage: String = ""
    @State private var profileImage: UIImage?
    @State private var isShowingImagePicker = false
    @State private var isAccountCreated = false
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                HStack {
                    Text("Create")
                        .foregroundColor(Color.blue)
                        .padding(.trailing, -5.0)
                    Text("Account!")
                    Spacer()
                    Button(action: {
                        path.removeLast() // Navigate back to the previous view
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
                
                Text("Please Create Your OnCamp Account")
                
                if let selectedImage = profileImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .padding(.bottom, 5)
                } else {
                    Image(systemName: "person.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .padding(.bottom, 5)
                }
                
                Button(action: {
                    self.isShowingImagePicker = true
                }) {
                    Text("Upload Profile Picture")
                        .font(.headline)
                        .padding()
                        .foregroundColor(Color.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $isShowingImagePicker, onDismiss: loadImage) {
                    ImagePicker(image: self.$profileImage, sourceType: .photoLibrary)
                }
                
                Spacer()
                
                VStack(spacing: 16) {
                    GroupBox {
                        TextField("Username (Required)", text: $userData.username)
                            .padding(6)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .padding(.horizontal, 12)
                    }
                    .frame(width: 370.0)
                    .cornerRadius(30)
                    
                    GroupBox {
                        TextField("Biography (Max 150 characters)", text: $userData.bio)
                            .padding(6)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .padding(.horizontal, 12)
                    }
                    .frame(width: 370.0)
                    .cornerRadius(30)
                    
                    GroupBox {
                        Picker("Status", selection: $userData.status) {
                            ForEach(userData.statuses, id: \.self) { Text($0) }
                        }
                        .padding(6)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal, 100)
                    }
                    .frame(width: 370.0)
                    .cornerRadius(30)
                    
                    GroupBox {
                        Picker("School", selection: $userData.school) {
                            ForEach(userData.colleges, id: \.self) { Text($0) }
                        }
                        .padding(6)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal, 100)
                    }
                    .frame(width: 370.0)
                    .cornerRadius(30)
                }
                
                Spacer()
                
                Button(action: {
                    createAccount()
                }) {
                    Text("Continue")
                        .font(.headline)
                        .padding()
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("Got it!")))
                }
                
                // New navigation destination handling
                .navigationDestination(isPresented: $isAccountCreated) {
                    Interests(uid: self.uid, path: $path) // Pass the path binding
                }
            }
            .padding()
        }
        .ignoresSafeArea(.keyboard)
        .navigationBarBackButtonHidden()
    }
    
    private func loadImage() {
        guard let _ = profileImage else {
            self.alertMessage = "Please select a profile picture"
            self.showingAlert = true
            return
        }
    }
    
    private func createAccount() {
        guard let profileImage = self.profileImage else {
            self.alertMessage = "Please select a profile picture"
            self.showingAlert = true
            return
        }
        
        uploadProfileImage(profileImage) { result in
            switch result {
            case .success(let url):
                self.saveUserData(pfpUrl: url.absoluteString)
            case .failure(let error):
                self.alertMessage = "Error uploading profile image: \(error.localizedDescription)"
                self.showingAlert = true
            }
        }
    }
    
    private func uploadProfileImage(_ image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.4) else {
            completion(.failure(NSError(domain: "CreateAccount", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid image data"])))
            return
        }
        
        let storageRef = Storage.storage().reference().child("profile_pictures/\(uid).jpg")
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                } else if let url = url {
                    completion(.success(url))
                } else {
                    completion(.failure(NSError(domain: "CreateAccount", code: 0, userInfo: [NSLocalizedDescriptionKey: "URL not found"])))
                }
            }
        }
    }
    
    private func saveUserData(pfpUrl: String) {
        let fcmToken = UserDefaults.standard.string(forKey: "fcmToken") ?? ""
        let userRef = Firestore.firestore().collection("Users").document(uid)
        let userData = [
            "bio": userData.bio,
            "username": userData.username,
            "school": userData.school,
            "status": userData.status,
            "isVendor": userData.isVendor,
            "pfpUrl": pfpUrl,
            "FcmToken": fcmToken, // Include the FCM token here
        ] as [String: Any];    userRef.setData(userData) { error in
            if let error = error {
                self.alertMessage = "Error setting user data: \(error.localizedDescription)"
                self.showingAlert = true
            } else {
                print("User data saved successfully")
                self.isAccountCreated = true
            }
        }
    }
}

#Preview {
    CreateAccount(uid: "MN9JWn0N3IYlkDPVpjunmCZkwGz2", path: .constant(NavigationPath()))
}
