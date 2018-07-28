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
    
    func loginUser(user: User) -> Observable<User>{
        return Observable.create({ observer in
            self.db.collection("users")
                .whereField("UID", isEqualTo: user.UID)
                .rx
                .getDocuments()
                .subscribe(onNext: { documents in
                    if let document = documents.documents.first {
                        let user = try! FirestoreDecoder().decode(User.self, from: document.data())
                        self.updateUserData(updatedData: document.data() , documentID: document.documentID)
                        observer.onNext(user)
                    } else {
                        print("Document does not exist")
                        observer.onError(RxError.noElements)
                    }
                }, onError: { error in
                    observer.onError(error)
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        })
    }
    
    func registerUser(_ user: User) -> Observable<User> {
        var userData = try! FirestoreEncoder().encode(user)
        userData["createdAt"] = Timestamp()
        return self.db.collection("users")
            .addDocument(data: userData)
            .rx
            .getDocument()
            .flatMap({ doc -> Observable<User> in
                let user = try! FirestoreDecoder().decode(User.self, from: (doc?.data())!)
                return Observable.just(user)
            })
    }
    
    func fetchCurrentUserReference() -> Observable<DocumentReference> {
        let userId = Auth.auth().currentUser?.uid ?? ""
        return self.db.collection("users")
            .whereField("UID", isEqualTo: userId)
            .rx
            .getDocuments()
            .flatMap({ query -> Observable<DocumentReference> in
                return Observable.just(query.documents[0].reference)
            })
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
                    if (!snapshot.documents.isEmpty){
                        let user = try! FirestoreDecoder().decode(User.self, from: snapshot.documents[0].data())
                        observer.onNext(user)
                    } else {
                        observer.onError(RxError.noElements)
                    }
                }, onError: { error in
                    observer.onError(error)
                    print("Error obteniendo usuario con UID: \(uid)")
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    private func updateUserData(updatedData: [String:Any], documentID: String) {
        db.collection("users")
            .document(documentID)
            .updateData(updatedData)
    }
    
    func getUserOffers(_ user: User) -> Observable<[Offer]> {
        var observables = [Observable<Offer>]()
        for offer in user.offers {
            observables.append(db.collection("offers")
                .document(offer.documentID)
                .rx
                .getDocument()
                .flatMap({ doc -> Observable<Offer> in
                    let offer: Offer = try! FirestoreDecoder().decode(Offer.self, from: (doc?.data())!)
                    return Observable.just(offer)
                }))
        }
        return Observable.zip(observables)
    }
    
    func logout() -> Observable<Bool> {
        return Observable.create( { observer in
            do {
                try Auth.auth().signOut()
                observer.onNext(true)
            } catch {
                observer.onNext(false)
            }
            return Disposables.create()
        })
        
    }
}
