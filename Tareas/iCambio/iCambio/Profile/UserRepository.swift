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
import CodableFirebase
import RxSwift

class UserRepository: BaseRepository {
    let userSubject: PublishSubject<User> = PublishSubject()
    let usersImagesSubject: PublishSubject<(IndexPath,String)> = PublishSubject()
    let disposeBag = DisposeBag()
    
    func saveUser(userData: [String:Any]) {
        self.db.collection("users")
            .whereField("UID", isEqualTo: userData["UID"] as! String)
            .rx
            .getDocuments()
            .subscribe(onNext: { documents in
                if let document = documents.documents.first {
                    print("Document data: \(document.data())")
                    let currentUser = try! (FirestoreDecoder().decode(User.self, from: userData))
                    self.userSubject.onNext(currentUser)
                    self.updateUserData(updatedData: userData , documentID: document.documentID)
                } else {
                    print("Document does not exist")
                    self.db.collection("users").addDocument(data: userData){
                        error in
                        if let error = error {
                            print("Error al añadir usuario: \(error)")
                        } else {
                            print("Usuario añadido")
                            let currentUser = try! (FirestoreDecoder().decode(User.self, from: userData))
                            self.userSubject.onNext(currentUser)
                        }
                    }
                }
            }, onError: { error in
                print("Hubo un error \(error)")
            }).disposed(by: disposeBag)
    }
    
    func fetchCurrentUser() -> Observable<User> {
        // User is signed in.
        //Auth.auth().currentUser?.getIDToken(completion: )
        return Observable.create { observer in
            if Auth.auth().currentUser != nil {
            self.db.collection("users")
                .whereField("UID", isEqualTo: Auth.auth().currentUser?.uid ?? "")
                .rx
                .getDocuments()
                .subscribe(onNext: { documents in
                    if let document = documents.documents.first {
                        print("Document data: \(document.data())")
                        let user = try! FirestoreDecoder().decode(User.self, from: document.data())
                        observer.onNext(user)
                        self.userSubject.onNext(user)
                    }
                }, onError: { error in
                    print("Hubo un error \(error)")
                    observer.onError(error)
                    self.userSubject.onError(error)
                }).disposed(by: self.disposeBag)
            } else {
                // No user is signed in.
                observer.onError(RxError.noElements)
                self.userSubject.onError(RxError.noElements)
                print("No authenticated")
            }
            return Disposables.create()
        }
    }
    
    func getCurrentFireUser() -> Firebase.User? {
        return Auth.auth().currentUser
    }
    
    func getUserImageWith(uid: String) -> Observable<QuerySnapshot> {
         /*return Observable.create({ observer in
            
         })*/
            return self.db.collection("users")
            .whereField("UID", isEqualTo: uid)
            .rx
            .getDocuments()
            /*.subscribe(onNext: { documents in
                if let document = documents.documents.first {
                    print("Document data: \(document.data())")
                    let user = try! FirestoreDecoder().decode(User.self, from: document.data())
                    let resource = ImageResource(downloadURL: URL(string: user.imageURL)!, cacheKey: user.imageURL)
                    cell.userImageView.kf.setImage(with: resource)
                }
            }, onError: { error in
                print("Hubo un error \(error)")
            }).disposed(by: self.disposeBag)*/
        
    }
    
    func getUserWithUID(_ uid: String) -> Observable<User> {
        return Observable.create { observer in
            self.db.collection("users")
                .whereField("UID", isEqualTo: uid)
                .rx
                .getDocuments()
                .subscribe(onNext: { snapshot in
                    let user = try! FirestoreDecoder().decode(User.self, from: snapshot.documents[0].data())
                    observer.onNext(user)
                }, onError: { error in
                    observer.onError(error)
                    print("Error obteniendo usuario con UID: \(uid)")
                }).disposed(by: self.disposeBag)
            return Disposables.create()
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
                    let currentUser = try! (FirestoreDecoder().decode(User.self, from: updatedData))
                }, onError: { error in
                    print("Document not updated \(error)")
                })
            .disposed(by: disposeBag)
        
    }
}
