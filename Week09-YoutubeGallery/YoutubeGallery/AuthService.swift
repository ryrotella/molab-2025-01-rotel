//
//  AuthService.swift
//  YoutubeGallery
//
//  Created by Ryan Rotella on 4/3/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth


class AuthService: ObservableObject {
    @Published var currentUser: User?
    @Published var isLoggedIn = false
    @Published var username = ""
    
    init() {
        Auth.auth().addStateDidChangeListener { auth, user in
            self.currentUser = user
            self.isLoggedIn = user != nil
            if let user = user {
                self.fetchUsername(for: user.uid)
            }
        }
    }
    
    func fetchUsername(for userID: String) {
        let db = Firestore.firestore()
        db.collection("users").document(userID).getDocument { document, error in
            if let document = document, document.exists, let data = document.data() {
                self.username = data["username"] as? String ?? ""
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                completion(true, nil)
            }
        }
    }
    
    func signUp(email: String, password: String, username: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            
            guard let userID = result?.user.uid else {
                completion(false, "Failed to get user ID")
                return
            }
            
            // Save username
            let db = Firestore.firestore()
            db.collection("users").document(userID).setData([
                "username": username,
                "email": email
            ]) { error in
                if let error = error {
                    completion(false, error.localizedDescription)
                } else {
                    self.username = username
                    completion(true, nil)
                }
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
