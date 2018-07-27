//
//  ArticlesRepository.swift
//  iCambio
//
//  Created by José Brandon Vargas Mariñelarena on 02/05/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import Firebase
import FirebaseFirestore
import FirebaseStorage
import CodableFirebase
import RxSwift

class ArticlesRepository: BaseRepository, ArticlesRepositoryDelegate {

    let disposeBag = DisposeBag()
    private let articlesSubject = PublishSubject<Article>()
    
    override init() {
        super.init()
    }
    
    func addArticle(article: Article) -> Observable<DocumentReference> {
        var articleData = try! FirestoreEncoder().encode(article)
        articleData["updatedAt"] = Timestamp()
        return db.collection("articles")
            .rx
            .addDocument(data: articleData)
    }
    
    func listenAriticlesUpdates(){
        db.collection("articles")
            .whereField("available", isEqualTo: true)
            .order(by: "updatedAt", descending: false)
            .rx
            .listen()
            .subscribe(onNext: { snapshot in
                print("New articles: \(snapshot.documentChanges.count)")
                snapshot.documentChanges.forEach { diff in
                    let article: Article = try! FirestoreDecoder().decode(Article.self, from: diff.document.data())
                    if (diff.type == .added) {
                        print("New article: \(diff.document.data())")
                        self.articlesSubject.onNext(article)
                    }
                    if (diff.type == .modified) {
                        print("Modified article: \(diff.document.data())")
                    }
                    if (diff.type == .removed) {
                        print("Removed article: \(diff.document.data())")
                        self.articlesSubject.onNext(article)
                    }
                }
            }, onError: { error in
                print("Error fetching snapshots: \(error)")
            }).disposed(by: disposeBag)
    }
    
    func uploadImages(_ imagesURLs: Array<String>, completion: @escaping (_ urls: Array<String>, _ error: Error?) -> Void) {
        var uploadedImagesUrls: Array<String> = []
        
        let uploadSingleCallback: (_: URL?, _ error: Error?) -> Void = { url, error in
            if let url = url {
                uploadedImagesUrls.append(url.absoluteString)
                if imagesURLs.count == uploadedImagesUrls.count {
                    completion(uploadedImagesUrls, nil)
                }
            } else {
                completion(uploadedImagesUrls, error)
            }
        }
        
        if (imagesURLs.count > 0) {
            for imageURL in imagesURLs {
                uploadImage(imageURL, completion: uploadSingleCallback)
            }
        } else {
            completion(uploadedImagesUrls, nil)
        }
    }
    
    func uploadImage(_ imageURL: String, completion: @escaping (_ url: URL?, _ error: Error?) -> Void )  {
        let storageRef = storage.reference().child("articles/\(imageURL.hashValue)")
        // Local file you want to upload
        let localFile = URL(string: imageURL)!
        
        // Create the file metadata
        let metadata = StorageMetadata(dictionary: ["contentType" : "image/jpeg"])
        //metadata.contentType = "image/jpeg"
        
        // Upload file and metadata to the object 'images/mountains.jpg'
        let uploadTask = storageRef.putFile(from: localFile, metadata: metadata)
        
        // Listen for state changes, errors, and completion of the upload.
        uploadTask.observe(.resume) { snapshot in
            // Upload resumed, also fires when the upload starts
        }
        
        uploadTask.observe(.pause) { snapshot in
            // Upload paused
        }
        
        uploadTask.observe(.progress) { snapshot in
            // Upload reported progress
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
        }
        
        uploadTask.observe(.success) { snapshot in
            // Upload completed successfully
            snapshot.reference.downloadURL(completion: { (url, error) in
                completion(url, error)
            })
        }
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error as NSError? {
                switch (StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                    // File doesn't exist
                    break
                case .unauthorized:
                    // User doesn't have permission to access file
                    break
                case .cancelled:
                    // User canceled the upload
                    break
                    
                    /* ... */
                    
                case .unknown:
                    // Unknown error occurred, inspect the server response
                    break
                default:
                    // A separate error occurred. This is a good place to retry the upload.
                    break
                }
            }
        }
    }
    
    func getArticlesSubject() -> PublishSubject<Article> {
        return articlesSubject
    }
    
    func getUserArticles(subject: PublishSubject<Array<Article>>) {
        db.collection("articles")
            .whereField("userUID", isEqualTo: Auth.auth().currentUser?.uid ?? "")
            .whereField("available", isEqualTo: true)
            .order(by: "updatedAt", descending: true)
            .rx
            .getDocuments()
            .subscribe(onNext: { snapshot in
                print("User articles: \(snapshot.documents)")
                let articles = snapshot.documents.map({ (snapshot) -> Article in
                    let article = try! FirestoreDecoder().decode(Article.self, from: snapshot.data())
                    return article
                })
                subject.onNext(articles)
            }, onError: { error in
                print("Error fetching snapshots: \(error)")
                subject.onError(error)
            }).disposed(by: disposeBag)
    }
    
    func addArticleID(id: String, path: String) {
        db.document(path).updateData(["id": id])
    }
    
    func makeOffer(offer: Offer) -> Observable<DocumentReference> {
        var offerData = try! FirestoreEncoder().encode(offer)
        offerData["createdAt"] = Timestamp()
        return db.collection("offers")
                    .rx
                    .addDocument(data: offerData)
    }
    
    func changeArticleAvailability(documentsIds: Array<String> ,available: Bool) {
        for documentId in documentsIds {
            db.collection("articles")
                .document(documentId)        
                .updateData(["available": available])
        }
    }
    func getUserAvailableArticles() -> Observable<Array<Article>> {
        return Observable.create({ observer in
            self.db.collection("articles")
                .whereField("userUID", isEqualTo: Auth.auth().currentUser?.uid ?? "")
                .whereField("available", isEqualTo: true)
                .order(by: "updatedAt", descending: true)
                .rx
                .getDocuments()
                .subscribe(onNext: { snapshot in
                    print("User articles: \(snapshot.documents)")
                    let articles = snapshot.documents.map({ (snapshot) -> Article in
                        let article = try! FirestoreDecoder().decode(Article.self, from: snapshot.data())
                        return article
                    })
                    observer.onNext(articles)
                }, onError: { error in
                    print("Error fetching snapshots: \(error)")
                    observer.onError(error)
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        })
    }
    
    func getArticleName(id: String) -> Observable<String> {
        return db.collection("articles")
            .document(id)
            .rx
            .getDocument()
            .flatMap{ document -> Observable<String> in
                if let article = try? FirestoreDecoder().decode(Article.self, from: (document?.data())!) {
                   return Observable.just(article.name)
                } else {
                   return Observable.just("")
                }
                
            }
    }
}

protocol ArticlesRepositoryDelegate {
    func addArticle(article: Article) -> Observable<DocumentReference>
    func listenAriticlesUpdates()
    func getArticlesSubject() -> PublishSubject<Article>
    func getUserArticles(subject: PublishSubject<Array<Article>>)
    func addArticleID(id: String, path: String)
    func makeOffer(offer: Offer) -> Observable<DocumentReference>
    func changeArticleAvailability(documentsIds: Array<String> ,available: Bool)
}
