
//  CreatePost.swift
//  letsgetrich
//
//  Created by Michael Washington on 9/16/23.
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct CreatePost: View {
    @ObservedObject var postData = PostData()
    @State private var selectedOption: PostData.PostOption = .publicPost
    @State private var showDropdown = false
    @State private var postText = ""
    @FocusState private var isCreatingPost: Bool
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    let user: User
    @EnvironmentObject var appState: AppState
    
    private var characterCount: Int {
        postText.count
    }

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Create Post")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.blue)

                    Spacer()

                    Button(action: {
                        showingImagePicker = true
                    }) {
                        Image(systemName: "camera")
                            .font(.title)
                            .foregroundColor(Color.blue)
                    }
                }
                .padding(.horizontal)

                HStack {
                    CircularProfilePictureView(profilePictureURL: user.pfpUrl!)
                        .frame(width: 40, height: 40)
                    
                    Button(action: {
                        showDropdown.toggle()
                    }) {
                        Text(selectedOption.rawValue)
                            .foregroundColor(.white)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 15)
                            .background(Color.blue)
                            .cornerRadius(15)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                if showDropdown {
                    VStack(spacing: 8) {
                        ForEach(PostData.PostOption.allCases, id: \.self) { option in
                            Button(action: {
                                withAnimation {
                                    selectedOption = option
                                    showDropdown.toggle()
                                }
                            }) {
                                Text(option.rawValue)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                
                TextEditor(text: $postText)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .overlay(
                        Text("Share what's on your mind...")
                            .foregroundColor(.black.opacity(postText.isEmpty ? 1 : 0))
                            .padding(.horizontal)
                            .padding(.top, 20),
                        alignment: .topLeading
                    )
                    .focused($isCreatingPost)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            
                            Button("Done") {
                                isCreatingPost = false
                            }
                        }
                    }

                HStack {
                    Spacer()
                    Text("Character Count: \(characterCount)")
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)

                if let inputImage = inputImage {
                    Image(uiImage: inputImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .cornerRadius(8)
                }

                Button(action: {
                    createPost(pfpUrl: user.pfpUrl!, school: user.school)
                }) {
                    Text("Post")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()

                Divider()

                Spacer()

                Text("Have an Event You'd Like Posted?")
                    .font(.body)
                    .foregroundColor(Color("LTBL"))
                    .fontWeight(.heavy)

                Button(action: {
                    // Action for creating event
                }) {
                    Text("Create Event")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: self.$inputImage, sourceType: .photoLibrary)
            }
            .padding()
        }
    }
    private func createPost(pfpUrl: String, school: String) {
        let db = Firestore.firestore()
        let storage = Storage.storage()
        let postRef = db.collection("Posts").document()
        let posterUid = Auth.auth().currentUser!.uid
        let postId = postRef.documentID
        
        func uploadImageAndCreatePost() {
            let usersRef = db.collection("Users").document(posterUid)
            usersRef.getDocument { (document, error) in
                if let document = document, document.exists, let username = document.data()?["username"] as? String {
                    var postData: [String: Any] = [
                        "content": postText,
                        "postedAt": FieldValue.serverTimestamp(),
                        "postedBy": posterUid,
                        "security": selectedOption.rawValue,
                        "likeCount": 0,
                        "commentCount": 0,
                        "repostCount": 0,
                        "postId": postId,
                        "username": username,
                        "pfpUrl": pfpUrl,
                        "school": school
                    ]
                    
                    if let inputImage = inputImage, let imageData = inputImage.jpegData(compressionQuality: 0.8) {
                        let mediaRef = storage.reference().child("postMedia/\(postId).jpg")
                        mediaRef.putData(imageData, metadata: nil) { metadata, error in
                            guard metadata != nil else {
                                print("Error uploading image: \(error?.localizedDescription ?? "")")
                                return
                            }
                            mediaRef.downloadURL { url, error in
                                guard let downloadURL = url else {
                                    print("Error getting download URL: \(error?.localizedDescription ?? "")")
                                    return
                                }
                                postData["mediaUrl"] = downloadURL.absoluteString
                                
                                postRef.setData(postData) { error in
                                    if let error = error {
                                        print("Error setting post data: \(error.localizedDescription)")
                                    } else {
                                        print("Post data saved successfully")
                                        appState.selectedTab = 0
                                    }
                                }
                            }
                        }
                    } else {
                        postRef.setData(postData) { error in
                            if let error = error {
                                print("Error setting post data: \(error.localizedDescription)")
                            } else {
                                print("Post data saved successfully")
                                appState.selectedTab = 0
                            }
                        }
                    }
                } else {
                    print("Error fetching user data: \(error?.localizedDescription ?? "User document does not exist")")
                }
            }
        }
        
        uploadImageAndCreatePost()
    }
}
