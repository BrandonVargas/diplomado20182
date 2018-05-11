//
//  UserRepository.swift
//  iCambio
//
//  Created by José Brandon Vargas Mariñelarena on 14/04/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import RxSwift

class UserRepository: BaseRepository {
    let userSubject: PublishSubject<Void> = PublishSubject()
    let disposeBag = DisposeBag()
    
    func saveUser(userData: [String:Any]) {
        self.db.collection("users")
            .whereField("email", isEqualTo: userData["email"] as! String)
            .rx
            .getDocuments()
            .subscribe(onNext: { documents in
                if let document = documents.documents.first {
                    print("Document data: \(document.data())")
                    var userInfoToUpdate = document.data()
                    userInfoToUpdate.removeValue(forKey: "email")
                    self.updateUserData(updatedData: userInfoToUpdate , documentID: document.documentID)
                } else {
                    print("Document does not exist")
                    self.db.collection("users").addDocument(data: userData){
                        error in
                        if let error = error {
                            print("Error al añadir usuario: \(error)")
                        } else {
                            print("Usuario añadido")
                            self.userSubject.onNext(())
                        }
                    }
                }
            }, onError: { error in
                print("Hubo un error \(error)")
            }).disposed(by: disposeBag)
    }
    
    func getCurrentUser() -> User? {
        if Auth.auth().currentUser != nil {
            // User is signed in.
            print("Current User \(String(describing: Auth.auth().currentUser))")
            return User(UID: (Auth.auth().currentUser?.uid)!,
                        name: (Auth.auth().currentUser?.displayName)!,
                        email: (Auth.auth().currentUser?.email)!,
                        imageURL: (Auth.auth().currentUser?.photoURL?.absoluteString)!)
        } else {
            // No user is signed in.
            print("No authenticated")
            return nil
        }
    }
    
    private func updateUserData(updatedData: [String:Any], documentID: String) {
        //TODO: Format fields to match with firebase from here?
        db.collection("users")
            .document(documentID)
            .rx
            .updateData(updatedData)
            .subscribe(onNext: { _ in
                    print("Document successfully updated")
                    self.userSubject.onNext(())
                }, onError: { error in
                    print("Document not updated \(error)")
                })
            .disposed(by: disposeBag)
        
    }
}
